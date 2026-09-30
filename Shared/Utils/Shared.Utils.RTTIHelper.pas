unit Shared.Utils.RTTIHelper;

interface

uses
  System.SysUtils,
  System.Rtti,
  System.TypInfo,
  Data.DB;

type
  /// <summary>
  /// Atributo utilizado para mapear uma propriedade da entidade
  /// ao nome da coluna correspondente no banco de dados.
  /// </summary>
  ColumnAttribute = class(TCustomAttribute)
  private
    FColumnName: string;
  public
    constructor Create(const AColumnName: string);
    property ColumnName: string read FColumnName;
  end;

  /// <summary>
  /// Classe utilitária responsável por preencher, via RTTI, as
  /// propriedades de um objeto a partir dos campos de um TDataSet,
  /// respeitando o atributo [Column] quando presente.
  /// </summary>
  TRTTIMapper = class
  public
    class procedure PreencherObjeto(const AObjeto: TObject; const ADataSet: TDataSet); static;
    class function ObterNomeColuna(const AProperty: TRttiProperty): string; static;
  end;

implementation

{ ColumnAttribute }

constructor ColumnAttribute.Create(const AColumnName: string);
begin
  inherited Create;
  FColumnName := AColumnName;
end;

{ TRTTIMapper }

class function TRTTIMapper.ObterNomeColuna(const AProperty: TRttiProperty): string;
var
  LAttr: TCustomAttribute;
begin
  Result := AProperty.Name;
  for LAttr in AProperty.GetAttributes do
  begin
    if LAttr is ColumnAttribute then
    begin
      Result := ColumnAttribute(LAttr).ColumnName;
      Break;
    end;
  end;
end;

class procedure TRTTIMapper.PreencherObjeto(const AObjeto: TObject; const ADataSet: TDataSet);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LProp: TRttiProperty;
  LColuna: string;
  LField: TField;
  LValue: TValue;
begin
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(AObjeto.ClassType);

    for LProp in LType.GetProperties do
    begin
      if not LProp.IsWritable then
        Continue;

      LColuna := ObterNomeColuna(LProp);
      LField := ADataSet.FindField(LColuna);

      if not Assigned(LField) then
        Continue;

      case LProp.PropertyType.TypeKind of
        tkInteger, tkInt64:
          LValue := TValue.From<Integer>(LField.AsInteger);
        tkFloat:
          begin
            if LProp.PropertyType.Handle = TypeInfo(TDateTime) then
              LValue := TValue.From<TDateTime>(LField.AsDateTime)
            else
              LValue := TValue.From<Double>(LField.AsFloat);
          end;
        tkString, tkLString, tkWString, tkUString:
          LValue := TValue.From<string>(LField.AsString);
        tkEnumeration:
          begin
            if LProp.PropertyType.Handle = TypeInfo(Boolean) then
              LValue := TValue.From<Boolean>(LField.AsInteger <> 0)
            else
              LValue := TValue.FromOrdinal(LProp.PropertyType.Handle, LField.AsInteger);
          end;
      else
        Continue;
      end;

      LProp.SetValue(AObjeto, LValue);
    end;
  finally
    LContext.Free;
  end;
end;

end.

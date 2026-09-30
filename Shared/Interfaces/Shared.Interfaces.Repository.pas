unit Shared.Interfaces.Repository;

interface

uses
  System.Generics.Collections;

type
  IRepository<T: class, constructor> = interface
    ['{A1B2C3D4-1111-4A2B-9C3D-000000000001}']
    function GetById(const AId: Integer): T;
    function GetAll: TObjectList<T>;
    function Add(const AEntidade: T): Integer;
    procedure Update(const AEntidade: T);
    procedure Delete(const AId: Integer);
  end;

implementation

end.

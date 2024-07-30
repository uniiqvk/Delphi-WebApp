unit Unit1;

interface

uses
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Dialogs,
  Data.DB, Data.Win.ADODB, SysUtils, System.Classes;

type
  TForm1 = class(TForm)
    btnConnect: TButton;
    btnAddBook: TButton;
    btnListBooks: TButton;
    Memo1: TMemo;
    procedure btnConnectClick(Sender: TObject);
    procedure btnAddBookClick(Sender: TObject);
    procedure btnListBooksClick(Sender: TObject);
  private
    procedure ConnectToDatabase;
    procedure AddBook(Title, Author: string; PublishedYear: Integer; Genre: string);
    procedure ListBooks;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ADOConnection: TADOConnection;
  ADOQuery: TADOQuery;

implementation

{$R *.dfm}

procedure TForm1.ConnectToDatabase;
begin
  ADOConnection := TADOConnection.Create(nil);
  try
    ADOConnection.ConnectionString := 'Provider=SQLOLEDB;Data Source=YUOR_SERVER;' +    //Заменить название сервера
                                      'Initial Catalog=LibraryDB;' +
                                      'Integrated Security=SSPI;';
    ADOConnection.LoginPrompt := False;
    ADOConnection.Connected := True;

    ADOQuery := TADOQuery.Create(nil);
    ADOQuery.Connection := ADOConnection;

    Memo1.Lines.Add('Connected to the database successfully.');
  except
    on E: Exception do
    begin
      Memo1.Lines.Add('Error connecting to the database: ' + E.Message);
      FreeAndNil(ADOConnection);
      FreeAndNil(ADOQuery);
    end;
  end;
end;

procedure TForm1.AddBook(Title, Author: string; PublishedYear: Integer; Genre: string);
begin
  ADOQuery.SQL.Text := 'INSERT INTO Books (Title, Author, PublishedYear, Genre) VALUES (:Title, :Author, :PublishedYear, :Genre)';
  ADOQuery.Parameters.ParamByName('Title').Value := Title;
  ADOQuery.Parameters.ParamByName('Author').Value := Author;
  ADOQuery.Parameters.ParamByName('PublishedYear').Value := PublishedYear;
  ADOQuery.Parameters.ParamByName('Genre').Value := Genre;
  ADOQuery.ExecSQL;
  Memo1.Lines.Add('Book added: ' + Title);
end;

procedure TForm1.ListBooks;
begin
  ADOQuery.SQL.Text := 'SELECT * FROM Books';
  ADOQuery.Open;
  Memo1.Clear;
  while not ADOQuery.Eof do
  begin
    Memo1.Lines.Add('Title: ' + ADOQuery.FieldByName('Title').AsString);
    Memo1.Lines.Add('Author: ' + ADOQuery.FieldByName('Author').AsString);
    Memo1.Lines.Add('Published Year: ' + ADOQuery.FieldByName('PublishedYear').AsString);
    Memo1.Lines.Add('Genre: ' + ADOQuery.FieldByName('Genre').AsString);
    Memo1.Lines.Add('-----------------------');
    ADOQuery.Next;
  end;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  ConnectToDatabase;
end;

procedure TForm1.btnAddBookClick(Sender: TObject);
begin
  AddBook('Sample Title', 'Sample Author', 2023, 'Sample Genre');
end;

procedure TForm1.btnListBooksClick(Sender: TObject);
begin
  ListBooks;
end;

end.


unit hexaboutform;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmHexAboutDialog = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Bevel1: TBevel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    Label6: TLabel;
    Panel3: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHexAboutDialog: TfrmHexAboutDialog;

implementation

{$R *.DFM}

  procedure TfrmHexAboutDialog.Button1Click(Sender: TObject);
  begin
    Close;
  end;

end.

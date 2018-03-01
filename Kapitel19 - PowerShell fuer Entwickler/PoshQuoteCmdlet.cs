// Die Klasse PoshQuoteCmdlet definiert ein Cmdlet
// Setzt die Assembly System.Management.Automation voraus

using System;
using System.Management.Automation;
    
[Cmdlet(VerbsCommon.Get, "PoshQuote")]
public class PoshQuoteCmdlet : Cmdlet
{
    private string[] _quotes = {
              "Eile mit Weile", "Take it easy", "Lerne PowerShell",
              "Relax", "Dont worry, be happy", "Mach mal urlaub"
    };

    private bool _All;
    private bool _ThrowEvilError;
    private bool _NiceError;

    [Parameter(ParameterSetName="Evil")]
    public SwitchParameter ThrowEvilError
    {
        get { return _ThrowEvilError; }
        set { _ThrowEvilError = value; }
    } 

    [Parameter(ParameterSetName="Default")]
    public SwitchParameter NiceError
    {
        get { return _NiceError; }
        set { _NiceError = value; }
    } 
        
    [Parameter(ParameterSetName="Default")]
    public SwitchParameter All
    {
        get { return _All; }
        set { _All = value; }
    } 

    protected override void ProcessRecord()
    {
        if (_ThrowEvilError)
        {
            string errorId = "PoshQuoteCmdlet.Cmdlet.Error";
            ErrorCategory category = ErrorCategory.InvalidOperation;
            Exception ex = new InvalidOperationException("Hier ging etwas gehörig schief");
            ErrorRecord err = new ErrorRecord(ex, errorId, category, null);
            this.ThrowTerminatingError(err);
        }
        else if ( _NiceError)
        {
            string errorId = "PoshQuoteCmdlet.Cmdlet.Error";
            ErrorCategory category = ErrorCategory.InvalidOperation;
            Exception ex =  new InvalidOperationException("Nur eine kleine Störung, sorry");
            ErrorRecord err = new ErrorRecord(ex, errorId, category, null);
            WriteError(err);
        } 
        if (_All)
        {
            // string allQuotes = String.Join(";",_quotes);
            for(int i =  0; i < _quotes.Length; i++)
            {
                WriteObject(_quotes[i]);
            }
        }
        else
        {
            int i = new Random().Next(0, _quotes.Length);
            WriteObject(_quotes[i]);
        }
    }
}

using System.IO;
using System;


namespace PS.ThermoPropFromStructure.CoordParser {
    
class PDBParse : CoordParser {

    public PDBParse() {}
    public PDBParse(string FileName) {
        this.FileName = FileName;
    }
    public ~PDBParse() {
        fs.Close();
    }

    public override void read() {
        if (fs == null) {
            Console.Error.WriteLine("No filestream is currently open for the given class; unable to read");
            return;
        }

        StreamReader FSRead = new StreamReader(fs, System.Text.Encoding.UTF8, true, 1024);

        string FileLine;
        while ( (FileLine = FSRead.ReadLine()) != null ) {

            if ( FileLine.StartsWith("HETATOM") || FileLine.StartsWith("ATOM") ) {
                string[] SplitFileLine = FileLine.Split();
            }
        }
    }

}

}
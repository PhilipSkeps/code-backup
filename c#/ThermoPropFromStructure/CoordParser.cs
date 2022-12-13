using System;
using System.IO;
using System.Collections.Generic;

namespace PS.ThermoPropFromStructure.CoordParser {

public struct Atom {
    Byte ptcode;
    UInt64 num;
    float x;
    float y;
    float z;
    string residue;
}

public struct Molec {
    Atom atom;
    UInt64 num;
}

public abstract class CoordParser {

    /*
    H  => 0x1
    B  => 0x2
    C  => 0x4
    N  => 0x8
    O  => 0x10
    F  => 0x20
    Al => 0x40
    Si => 0x80
    P  => 0x100
    S  => 0x200
    Cl => 0x400
    Br => 0x800
    I  => 0x1000
    */
    private static Dictionary<UInt16, UInt16> BondMap;

    static CoordParser() {
        Dictionary<UInt16, float> BondMap = new Dictionary<UInt16, float>();
        BondMap.Add(0x1   , 0.74); // H - H
        BondMap.Add(0x3   , 1.19); // H - B
        BondMap.Add(0x5   , 1.09); // H - C
        BondMap.Add(0x9   , 1.01); // H - N
        BondMap.Add(0x11  , 1.16); // H - O
        BondMap.Add(0x21  , 0.91); // H - F
        BondMap.Add(0x41  , 1.79); // H - Al
        BondMap.Add(0x81  , 1.58); // H - Si
        BondMap.Add(0x101 , 1.42); // H - P
        BondMap.Add(0x201 , 1.34); // H - S
        BondMap.Add(0x401 , 1.28); // H - Cl
        BondMap.Add(0x801 , 1.42); // H - Br
        BondMap.Add(0x1001, 1.61); // H - I
        BondMap.Add(0x2   , 1.92); // B - B
        BondMap.Add(0x6   , 1.60); // B - C
        BondMap.Add(0xA   , 1.68); // B - N
        BondMap.Add(0x12  , 1.38); // B - O
        BondMap.Add(0x22  , 1.33); // B - F
        BondMap.Add(0x42  , 0.00); // B - Al DNE
        BondMap.Add(0x82  , 2.12); // B - Si
        BondMap.Add(0x102 , 1.79); // B - P
        BondMap.Add(0x202 , 1.74); // B - S
        BondMap.Add(0x402 , 1.74); // B - Cl
        BondMap.Add(0x802 , 1.90); // B - Br
        BondMap.Add(0x1002, 2.12); // B - I
        BondMap.Add(); // C - C
        BondMap.Add(); // C - N
        BondMap.Add(); // C - O
        BondMap.Add(); // C - F
        BondMap.Add(); // C - Al
        BondMap.Add(); // C - Si
        BondMap.Add(); // C - P
        BondMap.Add(); // C - S
        BondMap.Add(); // C - Cl
        BondMap.Add(); // C - Br
        BondMap.Add(); // C - I
        BondMap.Add(); // N - N
        BondMap.Add(); // N - O
        BondMap.Add(); // N - F
        BondMap.Add(); // N - Al
        BondMap.Add(); // N - Si
        BondMap.Add(); // N - P
        BondMap.Add(); // N - S
        BondMap.Add(); // N - Cl
        BondMap.Add(); // N - Br
        BondMap.Add(); // N - I
        BondMap.Add(); // O - O
        BondMap.Add(); // O - F
        BondMap.Add(); // O - Al
        BondMap.Add(); // O - Si
        BondMap.Add(); // O - P
        BondMap.Add(); // O - S
        BondMap.Add(); // O - Cl
        BondMap.Add(); // O - Br
        BondMap.Add(); // O - I
        BondMap.Add(); // F - F
        BondMap.Add(); // F - Al
        BondMap.Add(); // F - Si
        BondMap.Add(); // 
    }

    string filename;
    FileStream fs;
    string[] bonds;
    string[] angles;
    string[] dihedrals;
    string[] impropers;

    string FileName { 
        set {
            
            string TempFileName = Path.GetFullPath(value); 
            
            if ( File.Exists(TempFileName) ) {
                
                if (filename != null && File.Exists(filename)) {
                    fs.Close();
                }

                filename = TempFileName;
                fs = File.Open(filename, FileMode.Open, FileAccess.Read, FileShare.None);
            
            } else {
                Console.Error.WriteLine("Unable to fine file: ", TempFileName);
            }

        }
        get { return filename;  } 
    }
    string Extension { 
        get { return Path.GetExtension(filename); } 
    }
    FileStream FS { 
        get { return fs; } 
    }
    string[] Bonds { 
        get { return bonds; } 
    }
    string[] Angles { 
        get { return angles; } 
    }
    string[] Dihedrals { 
        get { return dihedrals; } 
    }
    string[] Impropers { 
        get { return angles; } 
    }

    private double distance(Atom Atom1, Atom Atom2) {
        return Math.Sqrt(Math.Pow((Atom1.x - Atom2.x), 2) + Math.Pow((Atom1.y - Atom2.y), 2) + Math.Pow((Atom1.z - Atom2.z), 2));
    }

    void read();
    void lex( /* some sort of set of groups */ );
    void angles() {}
    void dihedrals() {} // implement
    void impropers() {} // implement

}

}
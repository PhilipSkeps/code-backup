using System;
using System.Collections.Generic;

namespace PS {

class Learning {

    static int Main(string[] Args) {

        Console.WriteLine("Hello World");
        
        List<short> lst = new List<short>();
        for ( int iNdx = 0; iNdx < 10; iNdx++ ) {

            lst.Add(Convert.ToInt16(iNdx)); // no implicit conversion from larger to smaller types
        
        }

        Console.WriteLine(lst); // ToString method prints type if not overridden
        foreach ( short iNdx in lst ) { // foreach
        
            Console.WriteLine(iNdx);
        
        }

        Console.WriteLine(Environment.NewLine); // write a new line

        Console.WriteLine(Math.Max(2,3));

        string test = new string("");

        test = "TES";
        test = string.Concat(test, "T"); // can also concat with +
        
        Console.WriteLine($"Another concat method: {test}");
        Console.WriteLine($"first character: {test[0]}");

        // go over string methods

        switch(test) { // WTF switch with strings
            case "TEST":
            case "JUST LIKE C":
                Console.WriteLine("Here");
                break;
            default:
                Console.WriteLine("WTF");
                break;
        }

        int [,] testarray = new int[1,1]; // wacky two dimensional arrays

        testarray[0,0] = 30;

        Console.WriteLine(string.Concat("This worked: ",testarray[0,0]));

        Transportation.Car MyCar = new Transportation.Car();
        MyCar.honk();

        MyCar.Brand = "Honda";
        MyCar.Name = "Accord";
        MyCar.PaintColor = ColurUtil.Color.Blue;

        Console.WriteLine(MyCar); // ToString type overridden

        try {
            int[] myNumbers = {1, 2, 3};
            Console.WriteLine(myNumbers[10]);
        } catch (Exception Error) {
            Console.WriteLine(Error.Message);
        } finally {
            Console.WriteLine("Exitting");
        }

        return 1;

    }

}

}

using System;
using PS.ColurUtil;

namespace PS.Transportation {

class Car : IVehicle {

    private string brand;
    private string name;
    private Color paintColor;

    public Car() {
        
        this.name = "default constructor";
    
    }

    public Car(string Name, string Brand, Color PaintColor) {
        
        name = Name;
        brand = Brand;
        paintColor = PaintColor;
    }

    public void honk() {

        Console.WriteLine("beep beep");
    
    }

    public override string ToString() {

        return brand + " " + name + " " + paintColor.ToString();
    
    }

    public Color PaintColor {
        set { paintColor = value; }
        get { return paintColor;  }
    }

    public string Name {

        get { return name;  }
        
        set { name = value; }
    
    }

    public string Brand {

        get { return brand; }

        set { brand = value; }

    }

}

}
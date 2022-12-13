using System.Collections.Generic;

namespace PS.ThermoPropFromStructure.ThermoPropFunction {

    interface IThermoPropFunction {
        
        Dictionary<string, double[]> GroupTable { get; }

        static double calcProp();

    }
}
using System;

namespace PS.Transportation {

/*
 * Interfaces do not express something like "a Doberman is a type of dog and 
 * every dog can walk" but more like "this thing can walk"
 *
 * An abstract class can have shared state or functionality. An interface is only a promise to provide the state or functionality. 
 * A good abstract class will reduce the amount of code that has to be rewritten because it's functionality or 
 * state can be shared. The interface has no defined information to be shared
 *
 */

interface IVehicle {

    string Brand { set; get; } // must be implemented

    void honk(); // must be implemented

}

}
// See https://aka.ms/new-console-template for more information
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using System;

namespace PS.ReadIP {

class Application {
    static void Main(string[] Args) {
        
        UInt16 MaxLoginAttemptCount = 3;

        FirefoxOptions HeadlessMode = new FirefoxOptions();
        HeadlessMode.AddArguments("--headless");
        FirefoxDriver Driver = new FirefoxDriver(HeadlessMode);

        UInt16 LoginAttemptCount = 0;
        do {

            Console.WriteLine("Attempting to login to Xfinity Gateway");
            Driver.Navigate().GoToUrl("http://10.0.0.1/index.jst"); // login page
            
            Driver.FindElement(By.Id("username")).SendKeys("admin"); // login
            Driver.FindElement(By.Id("password")).SendKeys("95aD76ghJ1k"); // login

            Driver.FindElement(By.ClassName("form-btn")).Click(); // login
            Driver.Navigate().GoToUrl("http://10.0.0.1/network_setup.jst"); // move to the global ip page

            LoginAttemptCount++;

            while(Driver.Url == "http://10.0.0.1/network_setup.jst") {
                
                LoginAttemptCount = 0;

                string IPv4 = Driver.FindElement(By.XPath("/html/body/div[1]/div[3]/div[3]/div[2]/div[4]/span[2]")).GetAttribute("textContent");
                Console.WriteLine("IPv4: " + IPv4);
                System.Threading.Thread.Sleep(60000); // sleep for 1 minutes
                Driver.Navigate().Refresh();

            }

        } while(LoginAttemptCount < MaxLoginAttemptCount);

        Driver.Quit();
        Console.WriteLine("Maximized the amount of login attempts: " + MaxLoginAttemptCount + " >Fatal Error");

    }
}

}

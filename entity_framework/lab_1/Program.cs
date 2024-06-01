// See https://aka.ms/new-console-template for more information
using System;
using System.Linq;



public class Program
{
    public static void Main(string[] args)
    {
        MyDbContext myDbContext = new MyDbContext();
        myDbContext.Database.EnsureDeleted();
        myDbContext.Database.EnsureCreated();
        Console.WriteLine("Podaj zadanie które chcesz wykonać (a, b, c, d, e, f):");
        string? task = Console.ReadLine();
        switch (task)
        {
            case "a":
                ExerciseA exerciseA = new ExerciseA();
                exerciseA.run(myDbContext);
                break;
            case "b":
                ExerciseB exerciseB = new ExerciseB();
                exerciseB.run(myDbContext);
                break;
            case "c":
                ExerciseC exerciseC = new ExerciseC();
                exerciseC.run(myDbContext);
                break;
            case "d":
                ExerciseD exerciseD = new ExerciseD();
                exerciseD.run(myDbContext);
                break;
            case "e":
                ExerciseE exerciseE = new ExerciseE();
                exerciseE.run(myDbContext);
                break;
            case "f":
                ExerciseF exerciseF = new ExerciseF();
                exerciseF.run(myDbContext);
                break;
            default:
                Console.WriteLine("Nie ma takiego zadania");
                break;
        }

    }
}








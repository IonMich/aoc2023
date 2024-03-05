int[] Preprocess(string line)
{
    return line
        .Split(" ", StringSplitOptions.RemoveEmptyEntries)
        .Skip(1) // skip the first element that is just the label
        .Select(int.Parse)
        .ToArray();
}

int IntegersBetween(double a, double b)
{
    return (int)Math.Ceiling(b) - (int)Math.Floor(a) - 1;
}

const int acceleration = 1;
var lines = File.ReadAllLines("../inputs/input.txt");
var times = Preprocess(lines[0]);
var distances = Preprocess(lines[1]);
double sqrtTerm;
double t_min;
double t_max;
int possibilities;
int totalPossibilities = 1;

for (int i = 0; i < times.Length; i++)
{
    sqrtTerm = Math.Sqrt(times[i] * times[i] - 4 * distances[i]/acceleration);
    t_min = (times[i] - sqrtTerm) / 2D;
    t_max = (times[i] + sqrtTerm) / 2D;
    possibilities = IntegersBetween(t_min, t_max);
    totalPossibilities *= possibilities;
}

Console.WriteLine(totalPossibilities);
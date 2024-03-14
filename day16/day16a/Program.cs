var lines = File.ReadAllLines("../inputs/input.txt");

var matrix = lines.Select(x => x.ToCharArray()).ToArray();

var activeParticles = new List<Particle>()
{
    new(getTile(0, 0), new Direction(1, 0))
};
var particleHistory = new List<Particle>
{
    activeParticles[0]
};

Tile getTile(int x, int y)
{
    if (y < 0 || y >= matrix.Length || x < 0 || x >= matrix[0].Length)
    {
        return new Tile(new Location(-1, -1), ' ');
    }
    return new Tile(new Location(x, y), matrix[y][x]);
}


List<Direction> applyDirectionChange(Direction direction, char symbol)
{
    return symbol switch
    {
        '/' => [new Direction(-direction.Y, -direction.X)],
        '\\' => [new Direction(direction.Y, direction.X)],
        '.' => [direction],
        '-' => (direction.X == 0) ? [new Direction(1, 0), new Direction(-1, 0)] : [direction],
        '|' => (direction.Y == 0) ? [new Direction(0, 1), new Direction(0, -1)] : [direction],
        _ => throw new Exception("Invalid symbol")
    };
}

bool isTileOutOfBounds(Tile tile)
{
    return tile.Location.X < 0 || tile.Location.X >= matrix.Length || tile.Location.Y < 0 || tile.Location.Y >= matrix[0].Length;
}

int countDistinctParticleLocations(List<Particle> particles)
{
    return particles.Select(x => x.Tile.Location).Distinct().Count();
}

bool checkDejaVu(Particle particle)
{
    return particleHistory.Where(x=> x == particle).Count() > 1;
}

const int MAX_STEPS = 1000;
var i = 0;
while (activeParticles.Count > 0 && i < MAX_STEPS)
{
    var newParticles = new List<Particle>();
    foreach (var particle in activeParticles)
    {   
        if (checkDejaVu(particle))
        {
            // Console.WriteLine($"Particle {particle} is in a loop. Removing it");
            continue;
        }
        var newDirections = applyDirectionChange(particle.Direction, particle.Tile.Symbol);
        foreach (var newDirection in newDirections)
        {
            var newLocation = new Location(particle.Tile.Location.X + newDirection.X, particle.Tile.Location.Y + newDirection.Y);
            var newTile = getTile(newLocation.X, newLocation.Y);
            if (isTileOutOfBounds(newTile))
            {
                // Console.WriteLine($"Particle {particle} is out of bounds. Skipping it");
                continue;
            }
            newParticles.Add(new Particle(newTile, newDirection));
        }
    }
    activeParticles = newParticles;
    particleHistory.AddRange(activeParticles);
}
Console.WriteLine($"{countDistinctParticleLocations(particleHistory)}");


record Location(int X, int Y);
record Tile(Location Location, char Symbol);
record Direction(int X, int Y);
record Particle(Tile Tile, Direction Direction)
{
    public override string ToString()
    {
        return $"Tile: ({Tile.Location.X}, {Tile.Location.Y}), Symbol: {Tile.Symbol}, Direction: ({Direction.X}, {Direction.Y})";
    }
}








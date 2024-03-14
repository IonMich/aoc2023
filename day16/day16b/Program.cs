var lines = File.ReadAllLines("../inputs/test_input.txt");

var matrix = lines.Select(x => x.ToCharArray()).ToArray();

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

List<ParticleState> getPathParticleStates(ParticleState activeParticle, List<ParticleState> seenStates)
{
    if (isTileOutOfBounds(activeParticle.Tile))
    {
        return [];
    }
    if (seenStates.Contains(activeParticle))
    {
        return [];
    }
    seenStates.Add(activeParticle);
    var currentLocation = activeParticle.Tile.Location;
    var newDirections = applyDirectionChange(activeParticle.Direction, activeParticle.Tile.Symbol);
    var newParticleStates = new List<ParticleState>();
    foreach (var direction in newDirections)
    {
        var newLocation = new Location(activeParticle.Tile.Location.X + direction.X, activeParticle.Tile.Location.Y + direction.Y);
        var newTile = getTile(newLocation.X, newLocation.Y);
        var newParticle = new ParticleState(newTile, direction);
        newParticleStates.Add(newParticle);
    }
    var nextParticleStates = newParticleStates.SelectMany(x => getPathParticleStates(x, seenStates)).ToList();
    nextParticleStates.Add(activeParticle);
    return nextParticleStates;
}

List<ParticleState> createInitialParticlesOnEdges()
{
    var particles = new List<ParticleState>();
    for (var i = 0; i < matrix.Length; i++)
    {
        particles.Add(new(getTile(0, i), new Direction(1, 0)));
        particles.Add(new(getTile(matrix[0].Length - 1, i), new Direction(-1, 0)));
    }
    for (var i = 0; i < matrix[0].Length; i++)
    {
        particles.Add(new(getTile(i, 0), new Direction(0, 1)));
        particles.Add(new(getTile(i, matrix.Length - 1), new Direction(0, -1)));
    }
    return particles;
}

int getDistinctLocationCount(List<ParticleState> particleStates)
{
    return particleStates.Select(x => x.Tile.Location).Distinct().Count();
}

int getMaxCascade()
{
    var particleStates = createInitialParticlesOnEdges();
    var maxCascade = 0;
    foreach (var particleState in particleStates)
    {
        Console.WriteLine($"Starting cascade from {particleState}");
        var initialParticleState = particleState;
        var path = getPathParticleStates(particleState, []);
        var cascadeCount = getDistinctLocationCount(path);
        Console.WriteLine($"Cascade: {cascadeCount} from {initialParticleState}. Max cascade: {maxCascade}");
        if (cascadeCount > maxCascade)
        {
            maxCascade = cascadeCount;
        }
    }
    return maxCascade;
}
Console.WriteLine($"Starting cascade");
Console.WriteLine($"{getMaxCascade()}");

record Location(int X, int Y);
record Tile(Location Location, char Symbol);
record Direction(int X, int Y);
record ParticleState(Tile Tile, Direction Direction)
{
    public override string ToString()
    {
        return $"Tile: ({Tile.Location.X}, {Tile.Location.Y}), Symbol: {Tile.Symbol}, Direction: ({Direction.X}, {Direction.Y})";
    }
}

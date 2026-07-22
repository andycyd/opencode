---
name: dotnet-gather-context
description: Gather context about a dotnet codebase
---

## When to use

Use this when you need to gather context about a dotnet codebase.

## Learn the folder structure

- list directories to learn what the folder structure to use

## Find the dotnet version

- find the `Directory.Build.props` file's `<TargetFramework>{version}</TargetFramework>` property to know what dotnet version the solution is using
- find all the `.csproj` files, and if any of them also set the `<TargetFramework>` property, alert the user, and recommend they let the `Directory.Build.props` file manage the version

## Find the NuGet package versions

- find the `Directory.Packages.props` file, and check what packages are installed in the solution, with what version
- if the file doesn't exist, alert the user, and recommend they migrate to centralized package management ([docs](https://learn.microsoft.com/en-us/nuget/consume-packages/Central-Package-Management))

## Learn the coding style and rules

- find the `Directory.Build.props` file's `<TreatWarningsAsErrors>`, `<EnforceCodeStyleInBuild>` and `<NoWarn>` properties
- find the `.editorconfig` file, and analyize what rules are enforced
    - if you do not understand a rule, look it up in the official documentation: https://learn.microsoft.com/en-us/dotnet/fundamentals/code-analysis/style-rules/language-rules
- find the `BannedSymbols.txt` file, and analyze what symbols are banned

### Learn the additional coding style preferences

- strive for simple, modular, human readable code
- avoid abstractions unless neccessary
- do not add comments

### Naming rules

- do not shorten names or use abbreviations, always use full words (e.g. `tempSymbol` is not acceptable, instead use `temperatureSymbol`)
- add measurements to variable names where it makes sense, e.g. `var overhead = 25;` is confusing, maybe it should be called `overheadInPixels`

#### Records

Always use immutable records to represent data. Mark properties as either `required` or nullable, and do not use a primary constructor.

```cs
public record Example
{
    public required string Text { get; init; }
    public DateTimeOffset? Timestamp { get; init; }
}
```

#### Prefer switch expressions over long if chains

Instead of:

```cs
if (value >= 1_000)
{
    // ..
}
if (value >= 100)
{
    // ..
}
if (value >= 10)
{
    // ..
}
return // ..;
```

Prefer using switch statements:

```cs
return value switch
{
    >= 1_000=> // ..,
    >= 100 => // ..,
    >= 10 => // ..,
    _ => // .."
};
```
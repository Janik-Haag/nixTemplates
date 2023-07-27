# My Personal Nix templates

ToDo

## I have this in my flake.nix
```nix
inputs.myNixTemplates.url = "github:Janik-Haag/nixTemplates";
```

## And this in my "configuration.nix"
```nix
nix.registry = {
  personalTemplates.flake = inputs.myNixTemplates;
};
```


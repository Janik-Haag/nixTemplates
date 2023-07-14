{
  description = "My personal collection of flake templates";

  outputs = { self }: {

    templates = {

      python = {
        path = ./python;
        description = "A python flake template";
        welcomeText = ''
          ToDo
        '';
      };

    };

    # defaultTemplate = self.templates.trivial;

  };
}

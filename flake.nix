{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      basic = {
        path = ./basic;
        python = ./python;
        description = "A very basic flake";
      };

    };

    defaultTemplate = self.templates.basic;

  };
}


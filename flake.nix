{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      basic = {
        path = ./basic;
        description = "A very basic flake";
      };

    };

    defaultTemplate = self.templates.basic;

  };
}


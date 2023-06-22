{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      basic = {
        path = ./basic;
        description = "A very basic flake";
      };
      python = {
        path = ./python;
        description = "A very basic python flake";
      };
    };

    defaultTemplate = self.templates.basic;

  };
}


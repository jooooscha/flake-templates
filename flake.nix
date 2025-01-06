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
      rust = {
        path = ./rust;
        description = "A very basic rust flake";
      };
      latex = {
        path = ./latex;
        description = "A very basic latex flake";
      };
      jupyter = {
        path = ./jupyter;
        description = "A very basic jupyter flake";
      };
      pyproject = {
        path = ./pyproject;
        description = "A very basic pyproject flake";
      };
      poetry = { path  = ./poetry; };
      python-venv = {
        path = ./python-venv;
        description = "A very basic python flake using python venv";
      };
    };

    defaultTemplate = self.templates.basic;

  };
}


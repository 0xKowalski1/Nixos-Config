cd ~/nixConfig/node-packages
nix-shell -p nodePackages.node2nix --command "node2nix --nodejs-18 -i ./node-packages.json -o node-packages.nix"


{ pkgs, ...}:
{
    programs.vscode = {
            enable = true;
            package = pkgs.vscode;    
            extensions = with pkgs.vscode-extensions; [
                # Nix language support
                bbenoist.Nix
                ms-vscode.cpptools
                ms-python.python
                redhat.vscode-yaml
                ms-vscode-remote.remote-ssh
                ms-azuretools.vscode-docker
                ms-kubernetes-tools.vscode-kubernetes-tools
            ] 
            ++  pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                    name = "spellright";
                    publisher = "ban";
                    version = "3.0.52";
                    sha256 = "0i09asz9y51saarjx14nism0kq153fyps9588d1awc64bip496ra";
                }
                {
                    name = "language-hugo-vscode";
                    publisher = "budparr";
                    version = "1.2.0";
                    sha256 = "0gj15bi7yawgk1rjd5saw39jc33d4jnskspd5f93vx6yglqhajjj";
                }
                {
                    name = "better-toml";
                    publisher = "bungcip";
                    version = "0.3.2";
                    sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
                }
                {
                    name = "chef";
                    publisher = "chef-software";
                    version = "1.8.0";
                    sha256 = "0aqab7113qdk50xd39gzsc4022h2zn1yfxmkrpajvd5qnc49ns6n";
                }
                {
                    name = "gitlens";
                    publisher = "eamodio";
                    version = "11.0.0";
                    sha256 = "02flbimyk5kz7p3k42vn64rwb3dscy1mdn1yvxqxg9jc4jkdaarf";
                }
                {
                    name = "platformio-ide";
                    publisher = "platformio";
                    version = "2.2.1";
                    sha256 = "04rbcj0jc1m3xlmqlqj5p58w7wv1xqvkm7wjh97cbk03gr0vfqyx";
                }
                {
                    name = "vscode-direnv";
                    publisher = "Rubymaniac";
                    version = "0.0.2";
                    sha256 = "1gml41bc77qlydnvk1rkaiv95rwprzqgj895kxllqy4ps8ly6nsd";
                }
                {
                    name = "rust";
                    publisher = "rust-lang";
                    version = "0.7.8";
                    sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
                }
                {
                    name = "jenkins-jack";
                    publisher = "tabeyti";
                    version = "1.1.0";
                    sha256 = "1y3s7mwk7n37f3mkcyrk8wsniqsl8xdllgk6k0ghxhgyfrpk46kb";
                }
                {
                    name = "markdown-all-in-one";
                    publisher = "yzhang";
                    version = "3.4.0";
                    sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
                }
            ];
    };
}
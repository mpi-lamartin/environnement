# Environnement de développement pour les TP de MPI

Contient :
- `utop` comme interpréteur interactif OCaml
- `gcc` comme compilateur C (exemple : gcc test.c puis ./a.out)
- `ocaml` pour exécuter un fichier OCaml (exemple : ocaml test.ml)
- `ocamlopt` pour compiler un fichier OCaml (exemple : ocamlopt test.ml puis ./a.out)

Le Makefile est celui donné au TP d'informatique à CCINP et permet de simplifier les commandes.  
Par exemple, `make main` est un raccourci pour `gcc -o main.exe -Wall *.c -lm` : il compile tous les fichiers C et produit un exécutable `main.exe`.

> Extrait du rapport CCINP 2024  
> Cet énoncé est accompagné d’un code compagnon en C *.c fournissant certaines des fonctions mentionnées dans l’énoncé : il est à compléter en y implémentant les fonctions demandées.
> La ligne de compilation gcc -o main.exe -Wall *.c -lm vous permet de créer un exécutable main.exe à partir du ou des fichiers C fournis. Vous pouvez également utiliser l’utilitaire make. En ligne de commande, il suffit d'écrire make. Dans les deux cas, si la compilation réussit, le programme peut être exécuté avec la commande ./main.exe
> Il est possible d'activer davantage d'avertissements et un outil d'analyse de la gestion de la mémoire avec la ligne de compilation gcc -o main.exe -g -Wall -Wextra -fsanitize=address *.c -lm ou en écrivant make safe. L’examinateur pourra vous demander de compiler avec ces options.
> Si vous désirez forcer la compilation de tous les fichiers, vous pouvez au préalable nettoyer le répertoire en faisant make clean et relancer une compilation.


## Image préconstruite pour Codespaces

Codespaces télécharge `ghcr.io/mpi-lamartin/environnement:latest` : aucune
installation APT ni compilation OPAM n'est lancée à la création du Codespace.
Les extensions OCaml Platform et C/C++ Extension Pack ainsi que le thème
High Contrast sont conservés. Les trois messages d'aide s'affichent à
l'ouverture d'un terminal Bash.

L'image utilise Debian 13 (`trixie-slim`) et un utilisateur `vscode` avec sudo.
Elle contient `gcc` (avec les sanitizers), `gdb`, `make`, `sqlite3`, OCaml 5.3
(`ocaml`, `ocamlc`, `ocamlopt`), utop 2.16.0, ocamlformat 0.27.0
(avec `ocamlformat-rpc`) et ocaml-lsp-server 1.23.1 (`ocamllsp`).
Git et le client SSH restent disponibles pour les TP.

OPAM sert uniquement à construire les outils dans une étape Docker séparée.
L'image finale contient le compilateur Debian et les outils installés, sans
OPAM, dépôt de paquets ni sources de compilation. Les paquets APT sont installés
avec `--no-install-recommends` et leurs listes sont supprimées dans la même
couche. Les symboles de débogage des outils OCaml natifs sont supprimés ;
les programmes C des élèves restent débogables avec GDB. OCaml Platform utilise le sandbox `global` pour trouver ces outils.
Pour ajouter durablement une bibliothèque, modifier l'étape de construction
et republier l'image.

### Construction et publication

Le workflow [Build and publish Codespaces image](https://github.com/mpi-lamartin/environnement/actions/workflows/container.yml)
construit une image `linux/amd64`, adaptée à Codespaces :

- à chaque modification de `.devcontainer/` ou du workflow sur `main` ;
- chaque lundi pour intégrer les mises à jour Debian ;
- manuellement avec **Run workflow**.

Les pull requests construisent et testent l'image sans la publier. Le cache
GitHub Actions évite de recompiler les couches inchangées. Les tests exécutent
les outils de TP, compilent du C avec les sanitizers et du code OCaml en bytecode
et en natif, puis vérifient utop, le formatage, LSP et l'aide du terminal.
Seule l'image testée est publiée, avec les tags `latest` et `sha-<commit>`.
Le workflow utilise `GITHUB_TOKEN` avec `contents: read` et `packages: write` ;
aucun secret personnel n'est nécessaire.

### Accès à GHCR

Le package est privé car la politique de l'organisation interdit actuellement
les packages publics. Dans ses paramètres, **Manage Codespaces access** accorde
au dépôt `mpi-lamartin/environnement` le rôle **Read**. Les Codespaces créés depuis
ce dépôt peuvent ainsi récupérer l'image sans secret de registre personnel.
Cet accès doit être ajouté explicitement pour tout autre dépôt utilisant l'image
(y compris les forks). Un téléchargement Docker hors Codespaces nécessite une
authentification GHCR disposant du droit de lecture du package.

Si la politique de l'organisation autorise plus tard les packages publics,
rendre ce package public permettra les téléchargements anonymes. Un dépôt public
ne rend pas automatiquement son package public.

Après une mise à jour, reconstruire le Codespace pour récupérer la nouvelle
image. Pour revenir à une version précise, remplacer `latest` dans
`.devcontainer/devcontainer.json` par le tag `sha-<commit>` voulu.

Pour construire et tester localement depuis la racine du dépôt :

```sh
docker build -t mpi-environnement:test .devcontainer
docker run --rm -i mpi-environnement:test sh -s < .devcontainer/smoke-test.sh
```

Le Makefile à la racine reste celui des TP ; l'ancien Makefile de publication
Docker Hub dans `.devcontainer/` est remplacé par GitHub Actions.

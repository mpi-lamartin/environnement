# Environnement de développement pour les TP de MPI

Contient :
- `utop` comme interpréteur interactif OCaml
- `gcc` comme compilateur C (exemple : gcc test.c puis ./a.out)
- `ocaml` pour exécuter un fichier OCaml (exemple : ocaml test.ml)
- `ocamlopt` pour compiler un fichier OCaml

Le Makefile est celui donné au TP d'informatique à CCINP et permet de simplifier les commandes.  
Par exemple, `make main` est un raccourci pour `gcc -o main.exe -Wall *.c -lm` : il compile tous les fichiers C et produit un exécutable `main.exe`.

> Extrait du rapport CCINP 2024  
> Cet énoncé est accompagné d’un code compagnon en C *.c fournissant certaines des fonctions mentionnées dans l’énoncé : il est à compléter en y implémentant les fonctions demandées.
> La ligne de compilation gcc -o main.exe -Wall *.c -lm vous permet de créer un exécutable main.exe à partir du ou des fichiers C fournis. Vous pouvez également utiliser l’utilitaire make. En ligne de commande, il suffit d'écrire make. Dans les deux cas, si la compilation réussit, le programme peut être exécuté avec la commande ./main.exe
> Il est possible d'activer davantage d'avertissements et un outil d'analyse de la gestion de la mémoire avec la ligne de compilation gcc -o main.exe -g -Wall -Wextra -fsanitize=address *.c -lm ou en écrivant make safe. L’examinateur pourra vous demander de compiler avec ces options.
> Si vous désirez forcer la compilation de tous les fichiers, vous pouvez au préalable nettoyer le répertoire en faisant make clean et relancer une compilation.


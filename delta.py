import sys

# ./delta [arquivo_entrada.tm]  [arquivo_saida.txt]

file_inp = sys.argv[1]
file_out = sys.argv[2]
latex = False 

file = open(file_inp, "r")
open(file_out, 'w').close()


for line in file:

    if line.startswith(";") or line == "\n":
        continue


    if line.startswith("#"):
        # ans= line
        continue

        
    else:
        ans = ""
        l = line.split()

        Q = l[0]  # estado atual
        i = l[1]  # simb atual
        s = l[2]  # simb novo
        dir = l[3]  # dir
        E = l[4]  # estado novo

        d = ""
        for di in dir:
            if di == "r":
                d += "D"
            if di == "l":
                d += "E"
            if di == "*":
                d += "*"

        if (len(i)==1):  # 1 fita
            ans = (f"({Q}, {i}) = ({E}, {s}, {d})")

        else:           # 2 fitas
            ans = (f"({Q}, {i[0]}, {i[1]}) = ({E}, {s[0]}, {d[0]}, {s[1]}, {d[1]})")

        # Latex:  $(Estado, f1, f2) = (newEst, r1, d1, r2, d2)$
        # ans = (f"${({Q}, {i[0]}, {i[1]}) = ({E}, {s[0]}, {d[0]}{f2})}$\\\\\n")
        if latex:
            ans = (f"${ans}$\\\\")
            ans = ans.replace("_", "\_")
            ans = ans.replace("#", "\#")

        # Markdown: (Estado, f1, f2) = (newEst, r1, E1, r2, E2)
        # ans = (f"({Q}, {i[0]}{, {i[1]}}) = ({E}, {s[0]}, {d[0]}{f2})\n")

        ans +="\n"

    with open(file_out, 'a') as w:
        w.write(ans)

print("==== Done ====")


# <currStt0> <currSymbl> <newSymbl> <dir> <newStt>
# \\$ <currStt0> \times <currSymbl> \Rightarrow <newStt> \times <newSymbl> \times <E|D>$
# \\$Q \times \Gamma \Rightarrow Q \times \Gamma \times \{E,D\}$

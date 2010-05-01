#!/usr/bin/ruby -w

require 'etc'
require 'erb'
require 'optparse'

version = 1.6
err = 65
$script = File.basename $0
date = Time.now.strftime("%d %B %Y")

$options = {
    :outputdir     => Dir.getwd,
    :math?         => false,
    :listings?     => false,
    :fancyhdr?     => false,
    :pdf?          => false,
    :graphics?     => false,
    :listings_path => 'src/',
    :listings_conf => 'lst_conf',
    :graphics_path => 'fig/',
    :graphics_sum  => 'fig.tex.txt',
    :texfilename   => 'main',
    :filename      => 'main',
    :makefile      => 'Makefile',
    :author        => Etc.getpwnam(Etc.getlogin)['gecos'].split(',')[0],
    :title         => 'Document \LaTeX',
    :date          => '\today',
    :class         => 'article',
    :flyleaf       => 'flyleaf',
    :inc_path      => 'inc/',
    :packages      => []
}
$options[:author] = Etc.getlogin if $options[:author].nil?

class String
    def >> str
        str.insert(0, self)
    end
end

def echo str
    puts $script >> ": " << str
end

def touch file, template
    content = ERB.new(template).result
    f = File.open(file, 'w')
    f.write content
    f.close
end

def print_values
    printf("%-10s%-26s%s\n", "option :", "attribut :", "valeur :")
    puts "--------------------------------------------"
    printf("%-10s%-26s%s", "", "destination", $options[:outputdir])
    puts $options[:outputdir] == Dir.getwd ? " (dossier courant)" : ""
    printf("%-10s%-26s", "-m", "math")
    puts $options[:math?] ? "oui" : "non"
    printf("%-10s%-26s", "-l", "listings")
    puts $options[:listings?] ? "oui, dossier #{$options[:outputdir]}/#{$options[:listings_path]}" : "non"
    printf("%-10s%-26s", "-f", "fancyhdr")
    puts $options[:fancyhdr?] ? "oui" : "non"
    printf("%-10s%-26s", "-p", "config pdf")
    puts $options[:pdf?] ? "oui" : "non"
    printf("%-10s%-26s", "-i", "images")
    puts $options[:graphics?] ? "oui, dossier #{$options[:outputdir]}/#{$options[:graphics_path]}" : "non"
    printf("%-10s%-26s%s\n", "-n", "nom du fichier", $options[:filename])
    printf("%-10s%-26s%s\n", "-a", "auteur", $options[:author])
    printf("%-10s%-26s%s\n", "-t", "titre", $options[:title])
    printf("%-10s%-26s%s", "-d", "date", $options[:date])
    puts $options[:date] == '\today' ? " (" + date + ")" : ""
    printf("%-10s%-26s%s\n", "-c", "classe", $options[:class])
    printf("%-10s%-26s", "-P", "paquets supplementaires")
    puts $options[:packages].empty? ? "aucun" : "oui: " + $options[:packages].join(", ")
end

op = OptionParser.new do |o|
    o.on("-m", "--math",     "Paquets mathematiques")     { $options[:math?] = true }
    o.on("-l", "--listings", "Paquet Listings")           { $options[:listings?] = true }
    o.on("-f", "--fancyhdr", "Paquet Fancyhdr")           { $options[:fancyhdr?] = true }
    o.on("-p", "--pdf",      "Configuration pdf")         { $options[:pdf?] = true }
    o.on("-g", "--graphics", "Paquets pour images")       { $options[:graphics?] = true }
    o.on("-n", "--filename", "Definir un nom de fichier") { |v| $options[:filename] = v }
    o.on("-a", "--author",   "Definir l'auteur")          { |v| $options[:author] = v }
    o.on("-t", "--title",    "Definir le titre")          { |v| $options[:title] = v }
    o.on("-d", "--date",     "Definir la date")           { |v| $options[:date] = v }
    o.on("-c", "--class",    "Definir la classe")         { |v| $options[:class] = v }
    o.on("-P", "--package",  "Ajouter un paquet")         { |v| $options[:packages].push v }
    o.on("-v", "--version",  "Afficher la version")       { echo "version #{version}" ; exit }
end.parse!

if ARGV.length > 1
    echo "Mauvaise syntaxe."
    exit
elsif ARGV.length == 1 and ARGV.first != "."
    $options[:outputdir] = ARGV.first.chomp("/")
    Dir.getwd >> "/" >> $options[:outputdir] unless $options[:outputdir].chars.first == "/"
end

# demander confirmation
print_values
print "\nVoulez-vous continuer [Y/n/h] ? "
case STDIN.gets.strip
when 'Y', 'y', ''
when 'h'
    #TODO
    puts "help"
    exit
else
    echo "Abandon."
    exit
end

# verifier la destination
unless File.directory? $options[:outputdir]
    Dir.mkdir $options[:outputdir]
    Dir.chdir $options[:outputdir]
else
    Dir.chdir $options[:outputdir] unless $options[:outputdir] == Dir.getwd
    if File.exist? "#{$options[:texfilename]}.tex"
        puts "#{$options[:outputdir]}: il existe deja un fichier #{$options[:texfilename]}.tex"
        exit err
    elsif File.exist? $options[:makefile]
        puts "#{$options[:outputdir]}: il existe deja un #{$options[:makefile]}"
        exit err
    end
end

Dir.mkdir $options[:inc_path]
Dir.mkdir $options[:listings_path] if $options[:listings?]
Dir.mkdir $options[:graphics_path] if $options[:graphics?]

# creation du makefile
makefile_tpl = %q{
# <%= $options[:makefile] %> genere le <%= date %>
# par <%= $options[:author] %> a l'aide du script <%= $script %>

FINAL_FILENAME=<%= $options[:filename] %>
FILENAME=main
VIEWER=xdg-open
RUBBER=$(shell which rubber)

all: $(FILENAME).tex
ifeq ($(RUBBER),)
	@pdflatex $(FILENAME).tex
	@pdflatex $(FILENAME).tex
	@echo -e "\nIl est conseillé d'installer le paquet rubber."
else
	@$(RUBBER) -d $(FILENAME).tex
endif
	@mv $(FILENAME).pdf $(FINAL_FILENAME).pdf

view: all
	@$(VIEWER) $(FINAL_FILENAME).pdf

clean:
	@echo "cleaning..."
	@rm -f *.aux *.log *.out *.toc *.lol<% if $options[:listings?] %> *.lof<% end %><% if $options[:class] == "beamer" %> *.nav *.snm<% end %><% unless $options[:class] == "beamer" %>
	@rm -f inc/*.aux<% end %>
	@rm -f $(FINAL_FILENAME).tar

archive: all clean
	@tar -cf $(FINAL_FILENAME).tar *
	@echo "archived in $(FINAL_FILENAME).tar"
}.strip

file = $options[:makefile]
touch file, makefile_tpl
echo "creation du #{file}"

# liste des couleurs
colors_tpl = %q{
%         Colors    Bright Colors
% Black   #0F2130   #B0B3B9
% Red     #D22613   #F96795
% Green   #7CDE53   #A0F2A0
% Yellow  #EBE645   #F4EF82
% Blue    #2C9ADE   #A3FEFE
% Orange  #FFA705   #F1B356
% Cyan    #8A95A7   #B0C3DA
% White   #F8F8F8   #FFFFFF

\definecolor{myblack}{HTML}{0F2130}
\definecolor{myred}{HTML}{D22613}
\definecolor{mygreen}{HTML}{7CDE53}
\definecolor{myyellow}{HTML}{EBE645}
\definecolor{myblue}{HTML}{2C9ADE}
\definecolor{myorange}{HTML}{FFA705}
\definecolor{mycyan}{HTML}{8A95A7}
\definecolor{mywhite}{HTML}{F8F8F8}
\definecolor{mygrey}{HTML}{555753}
}.strip

# liste des commandes perso
commands_tpl = %q{
% raccourcis
\newcommand{\Cad}{C'est-à-dire~}
\newcommand{\cad}{c'est-à-dire~}
\newcommand{\pe}{peut-être~}

\newcommand{\todo}[1]{\bigskip \colorbox{myyellow}{\textcolor{mygrey}{\textsf{\textbf{TODO} #1 }}} \bigskip}

<% if opts[:pdf?] %>
\newcommand{\email}[1]{\href{mailto:#1}{\textsf{<#1>}}}
<% end %>

<% if $options[:graphics?] %>
% commande pour afficher un lien vers une image
\newcommand{\figref}[1]{\textsc{Fig.}~\ref{#1} (p.~\pageref{#1})}
<% end %>

<% if $options[:listings?] %>
% commande pour afficher le lien vers un listing :
\newcommand{\lstref}[1]{{\footnotesize Listing~\ref{#1}, p.~\pageref{#1}}}
<% end %>
}.strip

# liste des packages
packages_tpl = %q{
\usepackage[T1]{fontenc}      % codage des caracteres
\usepackage[utf8]{inputenc}   % encodage du fichier (utf8 ou latin1)
\usepackage[francais]{babel}  % langue
\usepackage{mathpazo}         % selection de la police
\usepackage{geometry}         % mise en page
\usepackage{xcolor}           % pour colorer des elements

<% if $options[:graphics?] %>
\usepackage{graphicx}         % pour inserer des images
<% end %>

<% if $options[:math?] %>
% math
\usepackage{amssymb}          % symboles mathematiques
%\usepackage{amsmath}         % commandes mathematiques
<% end %>

<% if $options[:pdf?] %>
% pdf
\usepackage{url}              % permet l'insertion d'url
\usepackage[pdftex]{hyperref} % permet l'hypertexte (rend les liens cliquables)
<% end %>

<% if $options[:listings?] %>
% listings
\usepackage{listings}         % permet d'inserer du code (multi-langage)
\usepackage{courier}
\usepackage{caption}
<% end %>

<% if $options[:fancyhdr?] %>
% fancyhdr
\usepackage{lastpage}         % derniere page
\usepackage{fancyhdr}         % en-tete et pied de page
<% end %>

\usepackage{multicol}
<% $options[:packages].each { |p| puts '\usepackage{' << p << '}' } %>
}.strip

# creation du fichier de config de listings si besoin
if $options[:listings?]
listings_tpl = %q{
% fichier de config du paquet listings genere le <%= date %>
% par <%= $options[:author] %> a l'aide du script <%= $script %>
%
% /!\ ne pas utiliser de caracteres accentues dans les sources (ne gere pas l'utf-8)
% pour remplacer les lettres accentues : sed -i -e "y/ÉÈÊÇÀÔéèçàôîêûùï/EEECAOeecaoieuui/" fichier

% configuration des listings par defaut :
\lstset{
    basicstyle=\footnotesize\ttfamily,
    %numbers=left,
    numberstyle=\tiny,
    %stepnumber=2,
    numbersep=5pt,
    tabsize=2,
    extendedchars=true,
    breaklines=true,
    frame=b,
    keywordstyle=\color{red},
    %keywordstyle=[1]\textbf,
    %keywordstyle=[2]\textbf,
    %keywordstyle=[3]\textbf,
    %keywordstyle=[4]\textbf,
    stringstyle=\color{white}\ttfamily,
    showspaces=false,
    showtabs=false,
    xleftmargin=17pt,
    framexleftmargin=17pt,
    framexrightmargin=5pt,
    framexbottommargin=4pt,
    %backgroundcolor=\color{lightgray},
    showstringspaces=false
}

\lstloadlanguages{
    %[Visual]Basic
    %Pascal
    %C
    %C++
    %XML
    %HTML
    %Java
}
%\DeclareCaptionFont{blue}{\color{blue}}

%\captionsetup[lstlisting]{singlelinecheck=false, labelfont={blue}, textfont={blue}}
\DeclareCaptionFont{white}{\color{white}}
\DeclareCaptionFormat{listing}{\colorbox[cmyk]{0.43, 0.35, 0.35,0.01}{\parbox{\textwidth}{\hspace{15pt}#1#2#3}}}
\captionsetup[lstlisting]{format=listing,labelfont=white,textfont=white, singlelinecheck=false, margin=0pt, font={bf,footnotesize}}

% configuration des listings C :
\lstnewenvironment{C}
{\lstset{%
    language=C,
    tabsize=3,
    xleftmargin=0.75cm,
    numbers=left,
    numberstyle=\tiny,
    extendedchars=true,
    %frame=single,
    %frameround=tttt,
    framexleftmargin=8mm,
    float,
    showstringspaces=true,
    showspaces=false,
    showtabs=false,
    breaklines=true,
    backgroundcolor=\color{mywhite},
    basicstyle=\color{myblack} \small,
    keywordstyle=\color{myred} \bfseries,
    ndkeywordstyle=\color{myred} \bfseries,
    commentstyle=\color{myblue} \itshape,
    identifierstyle=\color{myyellow},
    stringstyle=\color{mygreen}
}}
{}

% configuration des listings console :
\lstnewenvironment{console}
{\lstset{%
    language={},
    numbers=none,
    extendedchars=true,
    framexleftmargin=5mm,
    %float,
    showstringspaces=false,
    showspaces=false,
    showtabs=false,
    breaklines=false,
    backgroundcolor=\color{darkgray},
    basicstyle=\color{white} \scriptsize \ttfamily,
    keywordstyle=\color{white},
    ndkeywordstyle=\color{white},
    commentstyle=\color{white},
    identifierstyle=\color{white},
    stringstyle=\color{white}
}}
{}

\renewcommand{\lstlistlistingname}{Table des codes sources} % renommer la liste des listings

% un listing depuis un fichier s'importe comme ceci :
%\lstinputlisting[caption={Legende}, label=lst:label]{emplacement}
}.strip

    file = "#{$options[:listings_conf]}.tex"
    touch file, listings_tpl
    echo "creation du fichier #{file}"
end

# creation de la page de garde personnalisee si besoin
if $options[:class] == "report"
flyleaf_tpl = %q{
% page de garde personnalisee generee le <%= date %>
% par <%= $options[:author] %> a l'aide du script <%= $script %>
% voir http://zoonek.free.fr/LaTeX/LaTeX_samples_title/0.html pour d'autres modeles

\makeatletter
% commandes supplementaires
\def\location#1{\def\@location{#1}}
\def\blurb#1{\def\@blurb{#1}}

\def\clap#1{\hbox to 0pt{\hss #1\hss}}%
\def\ligne#1{%
    \hbox to \hsize{%
    \vbox{\centering #1}}%
}%
\def\haut#1#2#3{%
    \hbox to \hsize{%
    \rlap{\vtop{\raggedright #1}}%
    \hss
    \clap{\vtop{\centering #2}}%
    \hss
    \llap{\vtop{\raggedleft #3}}}%
}%
\def\bas#1#2#3{%
    \hbox to \hsize{%
    \rlap{\vbox{\raggedright #1}}%
    \hss
    \clap{\vbox{\centering #2}}%
    \hss
    \llap{\vbox{\raggedleft #3}}}%
}%
\def\maketitle{%
    \thispagestyle{empty}\vbox to \vsize{%
        \haut{}{\@blurb}{}
        \vfill
        \vspace{1cm}
        \begin{flushleft}
        \usefont{OT1}{ptm}{m}{n}
        \huge \@title
        \end{flushleft}
        \par
        \hrule height 4pt
        \par
        \begin{flushright}
        \Large \@author
        \par
        \end{flushright}
        \vspace{1cm}
        \vfill
        \vfill
        \bas{}{\@location, \@date}{}
    }%
    \cleardoublepage
}
\makeatother
}.strip

    file = "#{$options[:flyleaf]}.tex"
    touch file, flyleaf_tpl
    echo "creation du fichier #{file}"
end

# creation de l'aide-memoire pour les images si besoin
if $options[:graphics?]
graphics_sum_tpl = %q{
% aide-memoire pour l'insertion d'image sous LaTeX genere le <%= Time.now %>
% par <%= $options[:author] %> a l'aide du script <%= $script %>

% [!h] est facultatif, ca permet d'indiquer la position de la figure (si possible !)
% ! = forcer la position
% h = here
% t = top
% b = bottom
% p = page separee
% si il y a un probleme avec le positionnement, il peut etre force avec la position [H] (necessite le paquet float)

\begin{figure}[!h]
\begin{center}
%\includegraphics[width=5cm]{images/freebsd.png}
%\includegraphics[height=4cm]{images/freebsd.png}
\includegraphics{images/freebsd.png}
\caption{\label{freebsd}Logo de FreeBSD}
\end{center}
\end{figure}

% images cotes a cotes avec une seule legende
% note de bas de page dans un caption (\footnote ne peut pas etre utilise)
\begin{figure}[!h]
   \begin{center}
      \includegraphics[height=2cm]{images/freebsd.png}
      \hspace{1cm} % espace horizontal (facultatif)
      \includegraphics[height=2cm]{images/openbsd.png}
      \hspace{1cm}
      \includegraphics[height=2cm]{images/netbsd.png}
   \end{center}
   \caption{FreeBSD, OpenBSD et NetBSD\protect\footnotemark}
\end{figure}
\footnotetext{Tous des systemes d'exploitation libres.}

% images cotes a cotes avec une legende pour chaque
% si 2 images, mettre comme largeur 0.5\textwidth
\begin{figure}[!h]
\begin{minipage}{0.33\textwidth}
   \begin{center}
      \includegraphics[height=2cm]{images/freebsd.png}
      \caption{FreeBSD}
   \end{center}
\end{minipage}
\begin{minipage}{0.33\textwidth}
   \begin{center}
      \includegraphics[height=2cm]{images/openbsd.png}
      \caption{OpenBSD}
   \end{center}
\end{minipage}
\begin{minipage}{0.33\textwidth}
   \begin{center}
      \includegraphics[height=2cm]{images/netbsd.png}
      \caption{NetBSD}
   \end{center}
\end{minipage}
\end{figure}
}.strip

    file = $options[:graphics_sum]
    touch file, graphics_sum_tpl
    echo "creation du fichier #{file}"
end

# creation du fichier tex
if opts[:class] == "beamer"
texfilename_tpl = %q{
% squelette LaTeX genere le <%= date %>
% par <%= $options[:author] %> a l'aide du script <%= $script %>

%%%%%%%%%%%%%
% PREAMBULE %
%%%%%%%%%%%%%

% http://latex-beamer.sourceforge.net/
% http://www.tex.ac.uk/tex-archive/macros/latex/contrib/beamer/doc/beameruserguide.pdf

\documentclass{<%= $options[:class] %>}
\usetheme{Warsaw}

<% if $options[:graphics?] %>
\graphicspath{{<%= $options[:graphics_path] %>}}                 % chemins vers les images
<% end %>

<% if $options[:listings?] %>
\include{<%= $options[:listings_conf] %>}                        % fichier de config du paquet listings
<% end %>

% informations du document
\author{<%= $options[:author] %>}
\date{Le <%= $options[:date] %>}
\title{<%= $options[:title] %>}
\institute{}

\AtBeginSubsection[]
{
  \begin{frame}<beamer>
    \frametitle{Plan}
    \tableofcontents[currentsection,currentsubsection]
  \end{frame}
}

%%%%%%%%%
% CORPS %
%%%%%%%%%

\begin{document} % debut du document

\begin{frame}
\titlepage
\end{frame}

\end{document} % fin du document
%EOF
}.strip
else
texfilename_tpl = %q{
% squelette LaTeX genere le <%= date %>
% par <%= $options[:author] %> a l'aide du script <%= $script %>

%%%%%%%%%%%%%
% PREAMBULE %
%%%%%%%%%%%%%

\documentclass[a4paper, 11pt]{<%= $options[:class] %>}           % format general
\geometry{top=2.5cm, bottom=2.5cm, left=2cm, right=2cm}

<% if $options[:graphics?] %>
\graphicspath{{<%= $options[:graphics_path] %>}}                 % chemins vers les images
<% end %>

<% $options[:fancyhdr?] %>
\pagestyle{fancy}
\lhead{<%= $options[:title] %>}
\chead{}
\rhead{\thepage/\pageref{LastPage}}
\lfoot{}
\cfoot{}
\rfoot{\footnotesize <%= $options[:author] %>}
%\renewcommand{\headrulewidth}{0pt}
%\renewcommand{\footrulewidth}{0.4pt}
\fancypagestyle{plain}{%                        % style des pages de titres
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
<% end %>

<% $options[:pdf?] %>
\hypersetup{%
    pdftitle    = {<%= $options[:title] %>},
    pdfauthor   = {<%= $options[:author] %>}
    pdfcreator  = {Texlive},
    pdfproducer = {Texlive},
    colorlinks  = true,
    linkcolor   = black,
    citecolor   = black,
    urlcolor    = black
}                                                   % informations du pdf
<% end %>

<% if $options[:listings?] %>
\include{<%= $options[:listings_conf] %>}                        % fichier de config du paquet listings
<% end %>

% informations du document
\author{<%= $options[:author] %>}
\date{Le <%= $options[:date] %>}
\title{<%= $options[:title] %>}

<% if $options[:class] == "report" %>
%\include{<%= $options[:flyleaf] %>} % page de garde personnalisee
%\location{}
%\blurb{}

\renewcommand{\thesection}{\Roman{part}.\arabic{section}} % redefinir la numerotation des sections (ex: I.2)

\newcommand{\unnumchap}[1]{%
    \chapter*{#1}%
    \addcontentsline{toc}{chapter}{#1}%
    \chaptermark{#1}%
}
<% end %>

\makeatletter
\@addtoreset{section}{part} % reprendre a partir de 1 les sections des parties suivantes
\makeatother

%\AtBeginDocument{%
%   \renewcommand{\abstractname}{} % renommer le resume
%}

%%%%%%%%%
% CORPS %
%%%%%%%%%

\begin{document} % debut du document

\maketitle % afficher le titre

% resume
\begin{abstract}
\end{abstract}

\tableofcontents % table des matieres

<% $options[:listings?] %>
\lstlistoflistings % tables des listings
<% end %>

<% if $options[:class] == "article" %>
\newpage
<% elsif $options[:class] == "report" %>
\unnumchap{Introduction}
<% end %>

\end{document} % fin du document
%EOF
}.strip
end

file = "#{$options[:texfilename]}.tex"
touch file, texfilename_tpl
echo "creation du fichier #{file}"

echo "OK"
exit

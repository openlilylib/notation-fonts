%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                             %
% This file is part of Stylesheets,                                           %
%                      ===========                                            %
% a library to manage and use style sheets and alternative fonts with         %
% the GNU LilyPond engraving software,                                        %
% belonging to openLilyLib (https://github.com/openlilylib/openlilylib        %
%              -----------                                                    %
%                                                                             %
% Stylesheets is free software: you can redistribute it and/or modify         %
% it under the terms of the GNU General Public License as published by        %
% the Free Software Foundation, either version 3 of the License, or           %
% (at your option) any later version.                                         %
%                                                                             %
% Stylesheets is distributed in the hope that it will be useful,              %
% but WITHOUT ANY WARRANTY; without even the implied warranty of              %
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               %
% GNU Lesser General Public License for more details.                         %
%                                                                             %
% You should have received a copy of the GNU General Public License           %
% along with Stylesheets.  If not, see <http://www.gnu.org/licenses/>.        %
%                                                                             %
% Stylesheets is maintained by                                                %
% - Urs Liska, ul@openlilylib.org                                             %
% - Kieren MacMillan, kieren_macmillan@sympatico.ca                           %
% - Abraham Lee, tisimst.lilypond@gmail.com                                   %
% Copyright Urs Liska / Kieren MacMillan, Abraham Lee, 2015                   %
%                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
  Main functionality for font selection.
%}

\version "2.19.12"

\include "__init__.ily"

% Starting with some helper commands
#(define (make-style-file name style)
   "Construct file name for included style sheet.
    Factored out because needed several times."
   (os-path-join-unix
    (append openlilylib-root '(notation-fonts fonts)
      (list
       (string->symbol
        (string-downcase
         (format "~a-~a.ily" name style)))))))


%%%% activate font extensions
% The Arnold font provides a number of extra glyphs, others may follow.
% This command loads a separate style sheet defining commands
% and articulations to make use of these extra glyphs.
% Don't call the function explicitly but set the 'extensions' option to ##t
% in the call of \useNotationFont.
#(define (use-font-extensions name)
   (let ((filename (make-style-file name "extensions")))
     (ly:message "Extension file: ~a" filename)
     (if (file-exists? filename)
         (if (lilypond-greater-than? "2.19.21")
             (ly:parser-include-string
              (ly:gulp-file filename))
             (ly:parser-include-string parser
               (ly:gulp-file filename)))
         (oll:warn 
           "No extensions available for font \"~a\". Skipping." name)
         )))

% Use a notation font with or without options.
% To be called as a toplevel command.
% Arguments:
% - options: ly:context-mod? ( a "\with {}" clause)
%   - brace: define brace font
%            - "none": default to Emmentaler
%            - omitted: use the same as the font name
%              or default to Emmentaler if there is no corresponding brace font
%   - style: load a style sheet for the font
%            - omitted: load the "-default" stylesheet
%                       (has to be provided by the library)
%   - roman:
%   - sans:
%   - typewriter: define serif, sans-serif, and monospace font, respectively
%            - omitted: use the lilypond default
% - name: Font name
%
% All arguments are case insensitive, so "Emmentaler" is
% equivalent to "emmentaler".
% Note: If the names do not contain characters beyond alphabetical
% and a hyphen (but no numbers), the quotation marks can be omitted,
% so
%    \useNotationFont Beethoven
% is valid while with
%    \useNotationFont "Gutenberg1939"
% the quotation marks are needed.
%
% Requesting a font name that is not present results in a warning,
% but errors due to "font not found" are avoided.

useNotationFont =
#(define-void-function (options name)
   ((ly:context-mod?) string?)
   (let ((use-name (string-downcase name)))
     (if
      (not (member use-name
             #{ \getChildOption global.installed-fonts
                #(cond
                  ((eq? 'svg (ly:get-option 'backend))
                   'svg)
                  ((eq? 'svg-woff (ly:get-option 'backend))
                   'woff)
                  (else 'otf))
             #}))
      (oll:warn "No font \"~a\" installed in this LilyPond installation. Skipping." name)
      (let*
       (
         ;; create an alist with options if they are given.
         ;; if the argument is not given or no options are defined
         ;; we have an empty list.
         (options
          (if options
              (map
               (lambda (o)
                 (cons (cadr o) (caddr o)))
               (ly:get-context-mods options))
              '()))
         ;; retrieve 'brace' name from options if given.
         ;; if not given we assume the same as the notation font
         (brace
          (or (assoc-ref options 'brace)
              name))
         (use-brace (string-downcase brace))
         ;; retrieve 'roman' name from options with "serif" default.
         (roman
          (or (assoc-ref options 'roman)
              "serif"))
         (use-roman (string-downcase roman))
         ;; retrieve 'sans' name from options with "sans-serif" default.
         (sans
          (or (assoc-ref options 'sans)
              "sans-serif"))
         (use-sans (string-downcase sans))
         ;; retrieve 'typewriter' name from options with "monospace" default.
         (typewriter
          (or (assoc-ref options 'typewriter)
              "monospace"))
         (use-typewriter (string-downcase typewriter))
         ;; retrieve 'style' option with "default" default ...
         (style
          (or (assoc-ref options 'style)
              "default"))
         ;; ... and produce include filename from it
         (style-file (make-style-file use-name style))
         (extensions (assoc-ref options 'extensions))
         )

       ;; Post-process options
       ;;
       ;; if 'none' is given as brace set to default "emmentaler"
       (if (and (assoc-ref options 'brace)
                (string=? "none" (assoc-ref options 'brace)))
           (begin
            (set! brace "Emmentaler")
            (set! use-brace "emmentaler")))

       ;; if a non-existent brace font is requested
       ;; (or none is requested and there is no brace available for the notation font)
       ;; issue a warning and reset to Emmentaler.
       (if (not (member use-brace
                  #{ \getChildOption global.installed-fonts
                     % Construct the right subtree to be matched
                     % according to the used backend.
                     #(string->symbol
                       (string-append
                        (cond
                         ((eq? 'svg (ly:get-option 'backend))
                          "svg")
                         ((eq? 'svg-woff (ly:get-option 'backend))
                          "woff")
                         (else "otf"))
                        "-brace"))
                  #}))
           (begin
            (oll:warn 
             "No \"~a\" brace font available for backend '~a. Use Emmentaler as default."
                brace (ly:get-option 'backend))
            (set! brace "Emmentaler")
            (set! use-brace "emmentaler")))

       ;; if a non-existent stylesheet is requested
       ;; issue a warning and reset to -default
       (if (not
            (or (string=? "none" style)
                (file-exists? style-file)))
           (begin
            (oll:warn 
              "Requested stylesheet \"~a\" doesn't exist for font \"~a\". Skipping." style name)
            (set! style-file #f)))

       ;; store options, these are used from the included load-font file
       #{ \setOption notation-fonts.font.name #name #}
       #{ \setOption notation-fonts.font.use-name #use-name #}
       #{ \setOption notation-fonts.font.brace #brace #}
       #{ \setOption notation-fonts.font.use-brace #use-brace #}
       #{ \setOption notation-fonts.font.roman #roman #}
       #{ \setOption notation-fonts.font.use-roman #use-roman #}
       #{ \setOption notation-fonts.font.sans #sans #}
       #{ \setOption notation-fonts.font.use-sans #use-sans #}
       #{ \setOption notation-fonts.font.typewriter #typewriter #}
       #{ \setOption notation-fonts.font.use-typewriter #use-typewriter #}

       ;; load font through an included file.
       ;; this is necessary so that file can set its own
       ;; \paper {} block.
       ;
       ; TODO:
       ; Find a way to pull that functionality in here.
       ; The problem seems to be that (even when wrapping the
       ; definition of 'fonts in a ly:parser-define call the
       ; properties of the \paper block (e.g. staff-height) are
       ; not available.
       ; I think one has to somehow access the current paper block
       ; through Scheme (I suspect there are options in the paper
       ; related ly: functions but I didn't succeed to find a solution).
       (let ((arg
              (format "\\include \"~a\""
                (os-path-join-unix (append openlilylib-root '(notation-fonts load-font))))))
         (ly:parser-include-string arg))
       (oll:log (*location*)
         (format "Font \"~a\" loaded successfully" name))

       ;; try to load font extensions if requested
       (if extensions (use-font-extensions name))

       ;; include the determined style file for the font
       ;; if not "none".
       (if (and style-file (not (string=? "none" style)))
           (if (lilypond-greater-than? "2.19.21")
               (ly:parser-include-string
                (format "\\include \"~a\"" style-file))
               (ly:parser-include-string parser
                 (format "\\include \"~a\"" style-file))))
       (oll:log (*location*) (format "Associated \"~a\" stylesheet loaded successfully" style))
       ))))

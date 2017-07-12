%%%% The stylesheet for ALLEGRETTO music notation font
%%%%
%%%% In order for this to work, this file's directory needs to
%%%% be placed in LilyPond's path
%%%%
%%%% NOTE: If a change in the staff-size is needed, include
%%%% this file after it, like:
%%%%
%%%% #(set-global-staff-size 17)
%%%% \include "allegretto.ily"
%%%%
%%%% Copyright (C) 2014-2017 Abraham Lee (abraham@musictypefoundry.com)

\version "2.19.12"

\paper {
  #(define fonts
    (set-global-fonts
    #:music "allegretto"
    #:brace "allegretto"
    #:factor (/ staff-height pt 20)
  ))
}

#(define (adjustStemTremolo grob)
  (let* ((width (ly:stem-tremolo::calc-width grob))
         (dir (ly:stem-tremolo::calc-direction grob)))
        (if (eq? dir DOWN)
            (* width 0.6)
            width
        )
        ))


\layout {
  \context {
    \Score
    \override StemTremolo.beam-width = #adjustStemTremolo
    \override Beam.beam-thickness = #0.2  % Default is 0.48
    \override Beam.length-fraction = #0.55  % Default is 1.0
    \override BarLine.hair-thickness = #2.0  % Default is 1.9
    \override BarLine.color = #(rgb-color 0.938 0.215 0.320)
    \override LaissezVibrerTie.thickness = #0  % Default is 1.2
    \override LaissezVibrerTie.line-thickness = #2  % Default is 0.8
    \override LaissezVibrerTie.color = #(rgb-color 0.414 0.711 0.867)
    \override RepeatTie.thickness = #0  % Default is 1.2
    \override RepeatTie.line-thickness = #2  % Default is 0.8
    \override RepeatTie.color = #(rgb-color 0.414 0.711 0.867)
    \override Tie.thickness = #0  % Default is 1.2
    \override Tie.line-thickness = #2  % Default is 0.8
    \override Tie.color = #(rgb-color 0.414 0.711 0.867)
    \override Slur.thickness = #0  % Default is 1.2
    \override Slur.line-thickness = #2  % Default is 0.8
    \override Slur.color = #(rgb-color 0.414 0.711 0.867)
    \override PhrasingSlur.thickness = #0  % Default is 1.1
    \override PhrasingSlur.line-thickness = #2  % Default is 0.8
    \override PhrasingSlur.color = #(rgb-color 0.414 0.711 0.867)
    \override SpanBar.color = #(rgb-color 0.938 0.215 0.320)
    \override SpanBarStub.color = #(rgb-color 0.938 0.215 0.320)
    \override Stem.thickness = #1.0  % Default is 1.3
    \override Stem.details.lengths = #'(3.5 3.5 3.5 3.5 4.052 4.604)  % Default is '3.5 3.5 3.5 4.25 5.0 6.0)
    \override SystemStartBar.thickness = #2.0
    \override SystemStartBar.color = #(rgb-color 0.938 0.215 0.320)
    \override SystemStartBrace.color = #(rgb-color 0.699 0.711 0.711)
    \override SystemStartBracket.padding = #0.25  % Default is 0.8
    \override SystemStartBracket.thickness = #0.15  % Default is 0.45
    \override SystemStartBracket.color =#(rgb-color 0.699 0.711 0.711)
    \override DynamicText.color = #(rgb-color 0.703 0.703 0.703)
    \override Hairpin.color = #(rgb-color 0.703 0.703 0.703)
  }
  \context {
    \Staff
    \override StaffSymbol.ledger-line-thickness = #'(2.0 . 0.0)  % Default is (1.0 . 0.1)
    \override StaffSymbol.color = #(rgb-color 0.699 0.711 0.711)
    %\override StaffSymbol.thickness = #0.76  % Default is 1.0
    \override LedgerLineSpanner.color = #(rgb-color 0.699 0.711 0.711)
  }
%  \context {
%    \StaffGroup
%    \override SystemStartBracket.padding = #0.25  % Default is 0.8
%    \override SystemStartBracket.thickness = #0.15  % Default is 0.45
%  }
%  \context {
%    \ChoirStaff 
%    \override SystemStartBracket.padding = #0.25  % Default is 0.8
%    \override SystemStartBracket.thickness = #0.15  % Default is 0.45
%  }
  \context {
    \Lyrics
    \override LyricText.color = #(rgb-color 0.703 0.703 0.703)
    \override LyricHyphen.color = #(rgb-color 0.703 0.703 0.703)
    \override LyricExtender.color = #(rgb-color 0.703 0.703 0.703)
  }
}


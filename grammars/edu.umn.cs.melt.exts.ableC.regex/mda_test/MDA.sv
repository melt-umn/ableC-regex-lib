grammar edu:umn:cs:melt:exts:ableC:regex:mda_test;

import edu:umn:cs:melt:ableC:host;

copper_mda testMatching(ablecParser) {
  edu:umn:cs:melt:exts:ableC:regex:regexMatching;
}

--copper_mda testMatchingVerbose(ablecParser) {
--  edu:umn:cs:melt:exts:ableC:regex:regexMatchingVerbose;
--}

copper_mda testLiterals(ablecParser) {
  edu:umn:cs:melt:exts:ableC:regex:regexLiterals;
  silver:regex:concrete_syntax;
}


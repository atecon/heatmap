PKG = heatmap
INP = heatmap.inp

$(PKG).gfn : $(INP) $(PKG).spec $(PKG)_help.md gui_help.md
	gretlcli -m $(INP)

$(PKG).zip : $(PKG).gfn examples
	echo makepkg $(PKG).zip | gretlcli -b -

install : $(PKG).zip
	echo "install ./$(PKG).zip --local" | gretlcli -b -

clean :
	rm -rf *~ $(PKG).gfn $(PKG).zip session.inp examples/*~

tarball : clean
	tar -cvzf ../heatmap.tar.gz *

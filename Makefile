default: front1.pdf back1.pdf front2.pdf back2.pdf

front.pdf back.pdf &: core_set.pdf expansion_set.pdf multiplayer.pdf
	sh build.sh

front1.pdf: front.pdf
	pdfjam $< 1-55 --papersize '{69mm,94mm}' --pagecolor 0,0,0 -o $@
back1.pdf: back.pdf
	pdfjam $< 1-55 --papersize '{69mm,94mm}' --pagecolor 0,0,0 -o $@

# Remove the two empty cards, and the hammer/anvil cards.
front2.pdf: front.pdf
	pdfjam $< 56-100,103-108,112,115- --papersize '{69mm,94mm}' --pagecolor 0,0,0 -o $@
back2.pdf: back.pdf
	pdfjam $< 56-100,103-108,112,115- --papersize '{69mm,94mm}' --pagecolor 0,0,0 -o $@

core_set.pdf: | time_barons_2e_pnp.zip
	unzip -j time_barons_2e_pnp.zip time_barons_2e_pnp/$@
expansion_set.pdf: | time_barons_2e_pnp.zip
	unzip -j time_barons_2e_pnp.zip time_barons_2e_pnp/$@
multiplayer.pdf: | time_barons_2e_pnp.zip
	unzip -j time_barons_2e_pnp.zip time_barons_2e_pnp/$@

time_barons_2e_pnp.zip:
	wget "http://www.time-barons.com/files/time_barons_2e_pnp.zip"

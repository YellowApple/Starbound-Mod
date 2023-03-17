MODNAME		=	StarboundMod

ifeq "$(shell uname)" "Linux"
PLATFORM	=	linux
endif
ifeq "$(shell uname)" "Darwin"
PLATFORM	=	macos
endif

SB_PACKER	=	../../$(PLATFORM)/asset_packer
OUT		=	./out

SRC_DIRS	= 	achievements ai animations behaviors biomes \
			celestial cinematics codex collections \
			cursors damage dialog dungeons effects \
			humanoid interface items leveling liquids \
			monsters music names npcs objects parallax \
			particles plants player projectiles quests \
			radiomessages recipes rendering scripts sfx \
			ships sky spawntypes species stagehands stats \
			tech tenants terrain tiles tilesets treasure \
			vehicles versioning weather
SRC_EXTS	=	config macros patch png wav

STEAMCMD	=	steamcmd +login $(STEAMCMD_USER)
STEAM_ID_PARSER	=	awk '/"publishedfileid"/{print $$2}' \
			metadata.vdf | sed 's/"//g'

$(OUT)/pkg/contents.pak: $(SRC_DIRS) $(SRC_EXTS)
	rm -rf $(OUT)/pkg
	mkdir -p $(OUT)/pkg
	$(SB_PACKER) $(OUT)/src $(OUT)/pkg/$(MODNAME).pak

$(OUT)/src:
	rm -rf $(OUT)/src
	mkdir -p $(OUT)/src
	cp _metadata $(OUT)/src/

$(SRC_DIRS): FORCE $(OUT)/src
	@cp -rv $@ $(OUT)/src/$@ 2>/dev/null \
		|| echo 'No $@ folder present in mod root; skipping'

$(SRC_EXTS): FORCE $(OUT)/src
	@cp -v *.$@ $(OUT)/src/ 2>/dev/null \
		|| echo 'No *.$@ files present in mod root; skipping'

upload: $(OUT)/pkg/contents.pak
	mkdir -p $(OUT)/workshop
	cp $(OUT)/pkg/$(MODNAME).pak $(OUT)/workshop/contents.pak
	cp preview.jpg $(OUT)/preview.jpg
	sed 's,{{PWD}},$(PWD),g' <metadata.vdf.template >metadata.vdf
	$(STEAMCMD) +workshop_build_item $(PWD)/metadata.vdf +quit
	$(eval STEAM_ID=$(shell $(STEAM_ID_PARSER)))
	sed -i 's/"publishedfileid" "0"/"publishedfileid" "$(STEAM_ID)"/g' \
		metadata.vdf.template

clean: FORCE
	rm -rf $(OUT)
	rm -f metadata.vdf

FORCE:

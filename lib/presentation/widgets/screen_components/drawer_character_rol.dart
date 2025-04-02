import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/dialogs/dialog_character_description.dart';

class DrawerCharacterRol extends StatelessWidget {
  final Map<String, dynamic> characterData;

  DrawerCharacterRol({super.key, required this.characterData});

  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerTheme = TextEditingController();

  @override
/// Builds a Drawer widget displaying various sections related to the
/// character's details.
///
/// This method constructs a Drawer containing the character's header, primary
/// attributes, health and defense stats, magical skills, equipment and treasure,
/// and companion information. If the character data or attributes are missing,
/// an error message is displayed. The drawer includes an option to delete the
/// current adventure, which triggers a confirmation dialog. Upon deletion
/// confirmation, the [CleanRolPlay] event is added to the [ChatBloc], and a
/// new [DialogCharacterDescription] is presented to start a new adventure.
///
/// The drawer's contents are dynamically built based on the presence of spells
/// and companion data. The sections are organized in a [ListView] with
/// appropriate titles and content widgets for each section, localized using
/// [AppLocalizations].
///
/// Returns a [Drawer] widget populated with character information or an error
/// message if data is incomplete.

  Widget build(BuildContext context) {
    final character = characterData['character'] as Map<String, dynamic>?;
    final attributes = character?['core_attributes'] as Map<String, dynamic>?;
    final spells = character?['spells'] as Map<String, dynamic>?;

    if (character == null || attributes == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.error_character_data_incomplete_or_null,
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
    final companion = character['companion'] as Map<String, dynamic>?;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(character),
          _buildSectionTitle(AppLocalizations.of(context)!.primary_attributes),
          _buildAttributesGrid(attributes, context),
          _buildSectionTitle(AppLocalizations.of(context)!.health_and_defense),
          _buildCombatStats(character, context),
          if (spells != null && spells.isNotEmpty)
            _buildSectionTitle(AppLocalizations.of(context)!.magical_skills),
          if (spells != null && spells.isNotEmpty)
            _buildSpellSection(spells, context),
          _buildSectionTitle(
              AppLocalizations.of(context)!.equipment_and_treasure),
          _buildEquipmentList(character),
          if (companion != null && companion.isNotEmpty)
            _buildSectionTitle(AppLocalizations.of(context)!.companion),
          if (companion != null && companion.isNotEmpty)
            _buildCompanionInfo(companion),
          const Divider(
            thickness: 2,
            color: Colors.brown,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(AppLocalizations.of(context)!
                          .confirm_delete_adventure),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<ChatBloc>().add(CleanRolPlay());
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return DialogCharacterDescription(
                                  controllerDescription: _controllerDescription, controllerTheme: _controllerTheme,
                                );
                              },
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.accept,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete, color: Colors.white),
              label: Text(AppLocalizations.of(context)!.delete_adventure),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

/// Builds the header section of the character drawer.
///
/// This header displays the character's name, race, class, and location
/// within a styled [DrawerHeader]. The character's name is shown in a large,
/// bold medieval style font, while the race and class are displayed in a
/// smaller font below it. The location is shown with an icon next to it,
/// all in an amber and grey color scheme. The layout is organized using
/// a [Column] and [Row] to ensure proper alignment and overflow handling.
///
/// The header is decorated with a brown background and a border for visual
/// distinction within the drawer.
///
/// Returns a [DrawerHeader] widget populated with character details.

  Widget _buildHeader(Map<String, dynamic> character) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.brown[800],
        border: Border.all(color: Colors.brown.shade900, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              character['name'],
              style: GoogleFonts.medievalSharp(
                textStyle: const TextStyle(
                  fontSize: 24,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              '${character['race']} - ${character['class']}',
              style: GoogleFonts.medievalSharp(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.amber[100],
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.landscape, color: Colors.grey, size: 16),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  character['location'],
                  style: GoogleFonts.medievalSharp(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a styled section title for the character drawer.
  ///
  /// This widget displays a section title in a bold, brown, medieval style
  /// font with a size of 18. The padding is set to 8 on the vertical axis and
  /// 16 on the horizontal axis. The title is displayed with a brown color
  /// with an opacity of 900.
  ///
  /// Returns a [Padding] widget with a [Text] widget as its child.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: GoogleFonts.medievalSharp(
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.brown[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

/// Builds a grid displaying character attributes.
///
/// This widget uses a [GridView] to show each character attribute in a
/// [Card]. Each card contains the attribute's name and value, styled in
/// a medieval theme. The grid is non-scrollable and contains three columns,
/// with each cell having a fixed aspect ratio.
///
/// The attributes are passed as a map, where the key is the attribute
/// abbreviation and the value is the attribute's value. The names of the
/// attributes are localized using [AppLocalizations].
///
/// - `attributes`: A map with keys as attribute abbreviations (e.g., 'STR',
///   'DEX') and values as the respective attribute values.
/// - `context`: The [BuildContext] used for localization and theming.
///
/// Returns a [GridView] widget displaying the character's attributes.

  Widget _buildAttributesGrid(
      Map<String, dynamic> attributes, BuildContext context) {
    final attributeNames = {
      'STR': AppLocalizations.of(context)!.strength,
      'DEX': AppLocalizations.of(context)!.dexterity,
      'CON': AppLocalizations.of(context)!.constitution,
      'INT': AppLocalizations.of(context)!.intelligence,
      'WIS': AppLocalizations.of(context)!.wisdom,
      'CHA': AppLocalizations.of(context)!.charisma,
    };

    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: attributes.entries.map((entry) {
        return Card(
          color: Colors.amber[50],
          elevation: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                attributeNames[entry.key] ?? entry.key,
                style: GoogleFonts.medievalSharp(
                  textStyle: TextStyle(
                    color: Colors.brown[800],
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                entry.value.toString(),
                style: GoogleFonts.medievalSharp(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Builds a row of three stat circles for the character's combat stats.
  ///
  /// The first circle is for the character's hit points, colored red.
  /// The second circle is for the character's armor class, colored blue.
  /// The third circle is for the character's level, colored green.
  ///
  /// - `character`: A map with the character's properties.
  /// - `context`: The [BuildContext] used for localization and theming.
  ///
  /// Returns a [Row] widget with three [CircleStat] widgets.
  Widget _buildCombatStats(
      Map<String, dynamic> character, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCircle('HP', character['hp'], Colors.red),
          _buildStatCircle(
              'CA', character['armor_class'].toString(), Colors.blue),
          _buildStatCircle(AppLocalizations.of(context)!.level,
              character['level'].toString(), Colors.green),
        ],
      ),
    );
  }

/// Builds a circular widget to display a single stat for a character.
///
/// This widget creates a circle with the given `color` and displays
/// the `value` in the center. Below the circle, it shows a `label` 
/// describing the stat. The circle is styled with a medieval theme
/// using the `GoogleFonts.medievalSharp`.
///
/// - `label`: A short description of the stat (e.g., 'HP', 'CA').
/// - `value`: The value of the stat to be displayed inside the circle.
/// - `color`: The color used for the circle and the value text.

  Widget _buildStatCircle(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            value,
            style: GoogleFonts.medievalSharp(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.medievalSharp(
            textStyle: TextStyle(
              color: Colors.brown[800],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a widget displaying the character's spell section.
  ///
  /// The section is composed of three parts:
  /// - A spell slot indicator for level 1 spells.
  /// - A list of known spells.
  /// - A list of cantrips.
  ///
  /// The widget is a [Column] with the above three parts.
  /// The column has a padding of 16 on both sides.
  ///
  /// - `spells`: A map with the character's spells, as returned by the
  ///   [CharacterData] class.
  /// - `context`: The [BuildContext] used for localization and theming.
  ///
  /// Returns a [Widget] representing the character's spell section.
  Widget _buildSpellSection(Map<String, dynamic> spells, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpellSlotIndicator(spells['spell_slots']['level_1'], context),
          const SizedBox(height: 10),
          _buildSpellList(AppLocalizations.of(context)!.known_spells,
              spells['known_spells']),
          _buildSpellList(
              AppLocalizations.of(context)!.cantrips, spells['cantrips']),
        ],
      ),
    );
  }

  /// Builds a row displaying the available spell slots for level 1 spells.
  ///
  /// This widget displays the label for level 1 spell slots and the
  /// current count of available spell slots out of the total.
  ///
  /// The label and the count are styled with a medieval theme using
  /// `GoogleFonts.medievalSharp`.
  ///
  /// - `spellSlots`: A map containing the 'available' and 'used' slots
  ///   for level 1 spells.
  /// - `context`: The [BuildContext] used for localization and theming.
  ///
  /// Returns a [Row] widget with the spell slot label and count.

  Widget _buildSpellSlotIndicator(
      Map<String, dynamic> spellSlots, BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.level_1_spell_slots,
          style: GoogleFonts.medievalSharp(
            textStyle: TextStyle(
              color: Colors.brown[800],
              fontSize: 14,
            ),
          ),
        ),
        Text(
          '${spellSlots['available'] - spellSlots['used']}/${spellSlots['available']}',
          style: GoogleFonts.medievalSharp(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a section displaying a list of spells.
  ///
  /// This widget displays a heading with the given [title] and a
  /// [Column] of [ListTile]s, each displaying a spell's name.
  ///
  /// The heading is styled with a medieval theme using
  /// `GoogleFonts.medievalSharp`.
  ///
  /// The [spells] parameter should be a [List] of [String]s or a
  /// [List] of [Map]s with a 'name' key containing the spell's name.
  ///
  /// Returns a [Column] widget with the heading and the list of spells.
  Widget _buildSpellList(String title, dynamic spells) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.medievalSharp(
            textStyle: TextStyle(
              color: Colors.brown[800],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          children: (spells as List).map((spell) {
            final name = spell is Map ? spell['name'] : spell;
            return ListTile(
              dense: true,
              leading: const Icon(Icons.auto_awesome, size: 16),
              title: Text(
                name.toString(),
                style: GoogleFonts.medievalSharp(
                  textStyle: TextStyle(
                    color: Colors.brown[700],
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Builds a list of the character's equipment.
  ///
  /// The [character] parameter should be a [Map] with a 'currency' key
  /// containing the character's currency and an 'equipment' key containing
  /// the character's equipment.
  ///
  /// Returns a [Column] widget with the currency display and the list of
  /// equipment.
  Widget _buildEquipmentList(Map<String, dynamic> character) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrencyDisplay(character['currency']),
          const SizedBox(height: 10),
          Column(
            children: (character['equipment'] as List).map((item) {
              return ListTile(
                dense: true,
                leading: const Icon(Icons.construction, size: 16),
                title: Text(
                  item.toString(),
                  style: GoogleFonts.medievalSharp(
                    textStyle: TextStyle(
                      color: Colors.brown[700],
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Builds a row of three [CoinDisplay] widgets to show the character's
  /// currency.
  ///
  /// The [currency] parameter should be a [Map] with 'gp', 'sp', and 'cp'
  /// keys for the gold, silver, and copper pieces, respectively.
  ///
  /// Returns a [Row] widget with the three [CoinDisplay]s, spaced around.
  Widget _buildCurrencyDisplay(Map<String, dynamic> currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCoinDisplay('GP', currency['gp'], Colors.amber),
        _buildCoinDisplay('SP', currency['sp'], Colors.grey),
        _buildCoinDisplay('CP', currency['cp'], Colors.orange[700]!),
      ],
    );
  }

  /// Builds a widget that displays a currency amount.
  ///
  /// The [type] parameter should be a string of either 'GP', 'SP', or 'CP'
  /// for the gold, silver, and copper pieces, respectively.
  ///
  /// The [amount] parameter is the amount of the currency to display.
  ///
  /// The [color] parameter is the color to use for the currency.
  ///
  /// Returns a [Row] widget with the currency icon and the amount, spaced
  /// around.
  Widget _buildCoinDisplay(String type, int amount, Color color) {
    return Row(
      children: [
        Icon(Icons.monetization_on, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          '$amount $type',
          style: GoogleFonts.medievalSharp(
            textStyle: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a card that displays information about a companion.
  ///
  /// The [companion] parameter should be a [Map] with 'name', 'race', and
  /// 'ability' keys containing the companion's name, race, and ability,
  /// respectively.
  ///
  /// Returns a [Card] widget with the companion's information.
  Widget _buildCompanionInfo(Map<String, dynamic> companion) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: Colors.green[50],
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${companion['name']} el ${companion['race']}',
                style: GoogleFonts.medievalSharp(
                  textStyle: TextStyle(
                    color: Colors.green[900],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                companion['ability'],
                style: GoogleFonts.medievalSharp(
                  textStyle: TextStyle(
                    color: Colors.green[800],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

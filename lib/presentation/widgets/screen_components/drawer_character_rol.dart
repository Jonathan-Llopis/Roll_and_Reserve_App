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

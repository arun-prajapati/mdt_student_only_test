import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Smart_Theory_Test/views/WebView.dart';

import '../../locater.dart';
import '../../responsive/percentage_mediaquery.dart';
import '../../services/navigation_service.dart';
import '../../widget/CustomAppBar.dart';

class HighwayCode extends StatefulWidget {
  @override
  ExpansionTileSampleState createState() {
    return new ExpansionTileSampleState();
  }
}

class ExpansionTileSampleState extends State<HighwayCode> {
  final NavigationService _navigationService = locator<NavigationService>();
  late List<Entry> changingData;

  @override
  void initState() {
    super.initState();
    this.changingData = generateData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          width: Responsive.width(100, context),
          height: Responsive.height(100, context),
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight,
              child: Column(
                children: <Widget>[
                  CustomAppBar(
                      preferedHeight: Responsive.height(15, context),
                      title: 'Highway Code',
                      textWidth: Responsive.width(45, context),
                      iconLeft: FontAwesomeIcons.arrowLeft,
                      onTap1: () {
                        _navigationService.goBack();
                      },
                      iconRight: null),
                  Expanded(
                    child: ListView.builder(
                      //shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) =>
                          new EntryItem(changingData[index]),
                      itemCount: changingData.length,
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, this.links,
      [this.subheading, this.children = const <Entry>[]]);

  final String title;
  final String links;
  final String? subheading;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
generateData() => <Entry>[
      new Entry(
        'Introduction',
        '',
        'Who The Highway Code is for, how its worded, the consequences of not following the rules, self-driving vehicles, and the hierarchy of road users (Rules H1 to H3).',
        <Entry>[
          new Entry('Introduction',
              'https://www.gov.uk/guidance/the-highway-code/introduction#introduction'),
          new Entry('Wording of The Highway Code',
              'https://www.gov.uk/guidance/the-highway-code/introduction#wording-of-the-highway-code'),
          new Entry('Knowing and applying the rules',
              'https://www.gov.uk/guidance/the-highway-code/introduction#knowing-and-applying-the-rules'),
          new Entry('Self-driving vehicles',
              'https://www.gov.uk/guidance/the-highway-code/introduction#self-driving-vehicles'),
          new Entry('Hierarchy of road users',
              'https://www.gov.uk/guidance/the-highway-code/introduction#hierarchy-of-road-users'),
        ],
      ),
      new Entry(
        'Rules for Pedestrians (1 to 35)',
        '',
        'Rules for pedestrians, including general guidance, crossing the road, crossings, and situations needing extra care.',
        <Entry>[
          new Entry('General guidance (rules 1 to 6)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-pedestrians-1-to-35#general-guidance-rules-1-to-6'),
          new Entry('Crossing the road (rules 7 to 17)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-pedestrians-1-to-35#crossing-the-road-rules-7-to-17'),
          new Entry('Crossings (rules 18 to 30)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-pedestrians-1-to-35#crossings-rules-18-to-30'),
          new Entry('Situations needing extra care (rules 31 to 35)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-pedestrians-1-to-35#situations-needing-extra-care-rules-31-to-35'),
        ],
      ),
      new Entry(
        'Rules for users of powered wheelchairs and mobility scooters (36 to 46)',
        '',
        'Rules for powered wheelchairs and mobility scooters, including on pavements and on the road.',
        <Entry>[
          new Entry(
              'Powered wheelchairs and mobility scooters (rules 36 to 37)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-users-of-powered-wheelchairs-and-mobility-scooters-36-to-46#powered-wheelchairs-and-mobility-scooters-rules-36-to-37'),
          new Entry('On pavements (rules 38 to 40)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-users-of-powered-wheelchairs-and-mobility-scooters-36-to-46#on-pavements-rules-38-to-40'),
          new Entry('On the road (rules 41 to 46)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-users-of-powered-wheelchairs-and-mobility-scooters-36-to-46#on-the-road-rules-41-to-46'),
        ],
      ),
      new Entry(
        'Rules about animals (47 to 58)',
        '',
        'Rules about animals, including horse-?drawn vehicles, horse riders and other animals.',
        <Entry>[
          new Entry('Horse-drawn vehicles (rules 47 to 48)',
              'https://www.gov.uk/guidance/the-highway-code/rules-about-animals-47-to-58#horse-drawn-vehicles-rules-47-to-48'),
          new Entry('Horse riders (rules 49 to 55)',
              'https://www.gov.uk/guidance/the-highway-code/rules-about-animals-47-to-58#horse-riders-rules-49-to-55'),
          new Entry('Other animals (rules 56 to 58)',
              'https://www.gov.uk/guidance/the-highway-code/rules-about-animals-47-to-58#other-animals-rules-56-to-58'),
        ],
      ),
      new Entry(
        'Rules for cyclists (59 to 82)',
        '',
        'Rules for cyclists, including an overview, road junctions, roundabouts and crossing the road.',
        <Entry>[
          new Entry('Overview (rules 59 to 71)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-cyclists-59-to-82#overview-rules-59-to-71'),
          new Entry('Road junctions (rules 72 to 75)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-cyclists-59-to-82#road-junctions-rules-72-to-75'),
          new Entry('Roundabouts (rules 76 to 78)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-cyclists-59-to-82#roundabouts-rules-76-to-78'),
          new Entry('Crossing the road (rules 79 to 82)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-cyclists-59-to-82#crossing-the-road-rules-79-to-82'),
        ],
      ),
      new Entry(
        'Rules for motorcyclists (83 to 88)',
        '',
        'Rules for motorcyclists, including helmets, carrying passengers, daylight riding and riding in the dark.',
        <Entry>[
          new Entry('General (rules 83 to 88)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-motorcyclists-83-to-88#general-rules-83-to-88'),
        ],
      ),
      new Entry(
        'Rules for drivers and motorcyclists (89 to 102)',
        '',
        'Rules for drivers and motorcyclists, including vehicle condition, fitness to drive, alcohol and drugs, what to do before setting off, vehicle towing and loading, and seat belts and child restraints.',
        <Entry>[
          new Entry('Vehicle condition (rule 89)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-drivers-and-motorcyclists-89-to-102#vehicle-condition-rule-89'),
          new Entry('Fitness to drive (rules 90 to 94)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-drivers-and-motorcyclists-89-to-102#fitness-to-drive-rules-90-to-94'),
          new Entry('Alcohol and drugs (rules 95 to 96)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-drivers-and-motorcyclists-89-to-102#alcohol-and-drugs-rules-95-to-96'),
          new Entry('Before setting off (rule 97)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-drivers-and-motorcyclists-89-to-102#before-setting-off-rule-97'),
          new Entry('Vehicle towing and loading (rule 98)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-drivers-and-motorcyclists-89-to-102#vehicle-towing-and-loading-rule-98'),
          new Entry('Seat belts and child restraints (rules 99 to 102)',
              'https://www.gov.uk/guidance/the-highway-code/rules-for-drivers-and-motorcyclists-89-to-102#seat-belts-and-child-restraints-rules-99-to-102')
        ],
      ),
      new Entry(
        'General rules, techniques and advice for all drivers and riders (103 to 158)',
        '',
        'Signals, stopping procedures, lighting, control of the vehicle, speed limits, stopping distances, lines and lane markings and multi-lane carriageways, smoking, mobile phones and sat nav.',
        <Entry>[
          new Entry('Signals (rules 103 to 106)',
              'https://www.gov.uk/guidance/the-highway-code/general-rules-techniques-and-advice-for-all-drivers-and-riders-103-to-158#signals-rules-103-to-106'),
          new Entry('Other stopping procedures (rules 107 to 112)',
              'https://www.gov.uk/guidance/the-highway-code/general-rules-techniques-and-advice-for-all-drivers-and-riders-103-to-158#other-stopping-procedures-rules-107-to-112'),
          new Entry('Lighting requirements (rules 113 to 116)',
              'https://www.gov.uk/guidance/the-highway-code/general-rules-techniques-and-advice-for-all-drivers-and-riders-103-to-158#lighting-requirements-rules-113-to-116'),
          new Entry('Control of the vehicle (rules 117 to 126)',
              'https://www.gov.uk/guidance/the-highway-code/general-rules-techniques-and-advice-for-all-drivers-and-riders-103-to-158#control-of-the-vehicle-rules-117-to-126'),
          new Entry('Lines and lane markings on the road (rules 127 to 132)',
              'https://www.gov.uk/guidance/the-highway-code/general-rules-techniques-and-advice-for-all-drivers-and-riders-103-to-158#lines-and-lane-markings-on-the-road-rules-127-to-132'),
          new Entry('Multi-lane carriageways (rules 133 to 143)',
              'https://www.gov.uk/guidance/the-highway-code/general-rules-techniques-and-advice-for-all-drivers-and-riders-103-to-158#multi-lane-carriageways-rules-133-to-143'),
          new Entry('General advice (rules 144 to 158)',
              'https://www.gov.uk/guidance/the-highway-code/general-rules-techniques-and-advice-for-all-drivers-and-riders-103-to-158#general-advice-rules-144-to-158'),
        ],
      ),
      new Entry(
        'Using the road (159 to 203)',
        '',
        'Rules for using the road, including general rules, overtaking, road junctions, roundabouts, pedestrian crossings and reversing.',
        <Entry>[
          new Entry('General rules (rules 159 to 161)',
              'https://www.gov.uk/guidance/the-highway-code/using-the-road-159-to-203#general-rules-rules-159-to-161'),
          new Entry('Overtaking (rules 162 to 169)',
              'https://www.gov.uk/guidance/the-highway-code/using-the-road-159-to-203#overtaking-rules-162-to-169'),
          new Entry('Road junctions (rules 170 to 183)',
              'https://www.gov.uk/guidance/the-highway-code/using-the-road-159-to-203#road-junctions-rules-170-to-183'),
          new Entry('Roundabouts (rules 184 to 190)',
              'https://www.gov.uk/guidance/the-highway-code/using-the-road-159-to-203#roundabouts-rules-184-to-190'),
          new Entry('Pedestrian crossings (rules 191 to 199)',
              'https://www.gov.uk/guidance/the-highway-code/using-the-road-159-to-203#pedestrian-crossings-rules-191-to-199'),
          new Entry('Reversing (200 to 203)',
              'https://www.gov.uk/guidance/the-highway-code/using-the-road-159-to-203#reversing-200-to-203'),
        ],
      ),
      new Entry(
        'Road users requiring extra care (204 to 225)',
        '',
        'Rules for road users requiring extra care, including pedestrians, motorcyclists and cyclists, other road users and other vehicles.',
        <Entry>[
          new Entry('Overview (rule 204)',
              'https://www.gov.uk/guidance/the-highway-code/road-users-requiring-extra-care-204-to-225#overview-rule-204'),
          new Entry('Pedestrians (rules 205 to 210)',
              'https://www.gov.uk/guidance/the-highway-code/road-users-requiring-extra-care-204-to-225#pedestrians-rules-205-to-210'),
          new Entry('Motorcyclists and cyclists (rules 211 to 213)',
              'https://www.gov.uk/guidance/the-highway-code/road-users-requiring-extra-care-204-to-225#motorcyclists-and-cyclists-rules-211-to-213'),
          new Entry('Other road users (rules 214 to 218)',
              'https://www.gov.uk/guidance/the-highway-code/road-users-requiring-extra-care-204-to-225#other-road-users-rules-214-to-218'),
          new Entry('Other vehicles (rules 219 to 225).',
              'https://www.gov.uk/guidance/the-highway-code/road-users-requiring-extra-care-204-to-225#other-vehicles-rules-219-to-225'),
        ],
      ),
      new Entry(
        'Driving in adverse weather conditions (226 to 237)',
        '',
        'Rules for driving in adverse weather conditions, including wet weather, icy and snowy weather, windy weather, fog and hot weather.',
        <Entry>[
          new Entry('Overview (rule 226)',
              'https://www.gov.uk/guidance/the-highway-code/driving-in-adverse-weather-conditions-226-to-237#overview-rule-226'),
          new Entry('Wet weather (rule 227)',
              'https://www.gov.uk/guidance/the-highway-code/driving-in-adverse-weather-conditions-226-to-237#wet-weather-rule-227'),
          new Entry('Icy and snowy weather (rules 228 to 231)',
              'https://www.gov.uk/guidance/the-highway-code/driving-in-adverse-weather-conditions-226-to-237#icy-and-snowy-weather-rules-228-to-231'),
          new Entry('Windy weather (rules 232 to 233)',
              'https://www.gov.uk/guidance/the-highway-code/driving-in-adverse-weather-conditions-226-to-237#windy-weather-rules-232-to-233'),
          new Entry('Fog (rules 234 to 236)',
              'https://www.gov.uk/guidance/the-highway-code/driving-in-adverse-weather-conditions-226-to-237#fog-rules-234-to-236'),
          new Entry('Hot weather (rule 237)',
              'https://www.gov.uk/guidance/the-highway-code/driving-in-adverse-weather-conditions-226-to-237#hot-weather-rule-237'),
        ],
      ),
      new Entry(
        'Waiting and parking (238 to 252)',
        '',
        'Rules for waiting and parking, including rules on parking at night and decriminalised parking enforcement.',
        <Entry>[
          new Entry('General (rule 238)',
              'https://www.gov.uk/guidance/the-highway-code/waiting-and-parking-238-to-252#general-rule-238'),
          new Entry('Parking (rules 239 to 247)',
              'https://www.gov.uk/guidance/the-highway-code/waiting-and-parking-238-to-252#parking-rules-239-to-247'),
          new Entry('Parking at night (rules 248 to 252)',
              'https://www.gov.uk/guidance/the-highway-code/waiting-and-parking-238-to-252#parking-at-night-rules-248-to-252'),
          new Entry('Decriminalised Parking Enforcement (DPE)',
              'https://www.gov.uk/guidance/the-highway-code/waiting-and-parking-238-to-252#dpe'),
        ],
      ),
      new Entry(
        'Motorways (253 to 274)',
        '',
        'Rules for motorways, including rules for signals, joining the motorway, driving on the motorway, lane discipline, overtaking, stopping and leaving the motorway.',
        <Entry>[
          new Entry('General (rules 253 to 254)',
              'https://www.gov.uk/guidance/the-highway-code/motorways-253-to-273#general-rules-253-to-254'),
          new Entry('Motorway signals (rules 255 to 258)',
              'https://www.gov.uk/guidance/the-highway-code/motorways-253-to-273#motorway-signals-rules-255-to-258'),
          new Entry('Joining the motorway (rule 259)',
              'https://www.gov.uk/guidance/the-highway-code/motorways-253-to-273#joining-the-motorway-rule-259'),
          new Entry('On the motorway (rules 260 to 263)',
              'https://www.gov.uk/guidance/the-highway-code/motorways-253-to-273#on-the-motorway-rules-260-to-263'),
          new Entry('Lane discipline (rules 264 to 266)',
              'https://www.gov.uk/guidance/the-highway-code/motorways-253-to-273#lane-discipline-rules-264-to-266'),
          new Entry('Overtaking (rules 267 to 269)',
              'https://www.gov.uk/guidance/the-highway-code/motorways-253-to-273#overtaking-rules-267-to-269'),
          new Entry('Stopping (rules 270 to 271)',
              'https://www.gov.uk/guidance/the-highway-code/motorways-253-to-273#stopping-rules-270-to-271'),
          new Entry('Leaving the motorway (rules 273 to 274)',
              'https://www.gov.uk/guidance/the-highway-code/motorways-253-to-273#leaving-the-motorway-rules-273-to-274'),
        ],
      ),
      new Entry(
        'Breakdowns and incidents (275 to 287)',
        '',
        'Rules for breakdowns and incidents, including rules for motorways, obstructions, incidents, incidents involving dangerous goods and documents.',
        <Entry>[
          new Entry('Place of relative safety (rule 275) ',
              'https://www.gov.uk/guidance/the-highway-code/breakdowns-and-incidents-274-to-287#place-of-relative-safety-rule-275'),
          new Entry('Breakdowns (rule 276)',
              'https://www.gov.uk/guidance/the-highway-code/breakdowns-and-incidents-274-to-287#breakdowns-rule-276'),
          new Entry('Additional rules for motorways (rules 277 to 278)',
              'https://www.gov.uk/guidance/the-highway-code/breakdowns-and-incidents-274-to-287#additional-rules-for-motorways-rules-277-to-278'),
          new Entry('Obstructions (rules 280)',
              'https://www.gov.uk/guidance/the-highway-code/breakdowns-and-incidents-274-to-287#obstructions-rules-280'),
          new Entry('Incidents (rules 281 to 283)',
              'https://www.gov.uk/guidance/the-highway-code/breakdowns-and-incidents-274-to-287#incidents-rules-281-to-283'),
          new Entry('Incidents involving dangerous goods (rules 284 to 285)',
              'https://www.gov.uk/guidance/the-highway-code/breakdowns-and-incidents-274-to-287#incidents-involving-dangerous-goods-rules-284-to-285'),
          new Entry('Documentation (rules 286 to 287)',
              'https://www.gov.uk/guidance/the-highway-code/breakdowns-and-incidents-274-to-287#documentation-rules-286-to-287'),
        ],
      ),
      new Entry(
        'Road works, level crossings and tramways (288 to 307)',
        '',
        'Rules for road works (including on high-speed roads), level crossings and tramways',
        <Entry>[
          new Entry('Road works (rule 288)',
              'https://www.gov.uk/guidance/the-highway-code/road-works-level-crossings-and-tramways-288-to-307#road-works-rule-288'),
          new Entry('Additional rules for high-speed roads (rules 289 to 290)',
              'https://www.gov.uk/guidance/the-highway-code/road-works-level-crossings-and-tramways-288-to-307#additional-rules-for-high-speed-roads-rules-289-to-290'),
          new Entry('Level crossings (rules 291 to 299)',
              'https://www.gov.uk/guidance/the-highway-code/road-works-level-crossings-and-tramways-288-to-307#level-crossings-rules-291-to-299'),
          new Entry('Tramways (rules 300 to 307)',
              'https://www.gov.uk/guidance/the-highway-code/road-works-level-crossings-and-tramways-288-to-307#tramways-rules-300-to-307'),
        ],
      ),
      new Entry(
        'Light signals controlling traffic',
        '',
        'Light signals used to control traffic, including traffic light signals, flashing red lights, motorway signals and lane control signals.',
        <Entry>[
          new Entry('Traffic light signals',
              'https://www.gov.uk/guidance/the-highway-code/light-signals-controlling-traffic#trafficlightsignals'),
          new Entry('Flashing red lights',
              'https://www.gov.uk/guidance/the-highway-code/light-signals-controlling-traffic#flashred'),
          new Entry('Motorway signals',
              'https://www.gov.uk/guidance/the-highway-code/light-signals-controlling-traffic#motorwaysignals'),
          new Entry('Lane control signals',
              'https://www.gov.uk/guidance/the-highway-code/light-signals-controlling-traffic#lanecontrol'),
        ],
      ),
      new Entry(
        'Signals to other road users',
        '',
        'Signals used to other road users, including direction indicator signals, brake light signals, reversing light signals and arm signals.',
        <Entry>[
          new Entry('Direction indicator signals',
              'https://www.gov.uk/guidance/the-highway-code/signals-to-other-road-users#directionindicators'),
          new Entry('Brake light signals',
              'https://www.gov.uk/guidance/the-highway-code/signals-to-other-road-users#brakelight'),
          new Entry('Reversing light signals',
              'https://www.gov.uk/guidance/the-highway-code/signals-to-other-road-users#reversinglight'),
          new Entry('Arm signals',
              'https://www.gov.uk/guidance/the-highway-code/signals-to-other-road-users#armsignals'),
          new Entry('Hazard lights',
              'https://www.gov.uk/guidance/the-highway-code/signals-to-other-road-users#hazard-lights'),
        ],
      ),
      new Entry(
        'Signals by authorised persons',
        '',
        'Signals used by authorised persons, including police officers, arm signals to persons controlling traffic, Driver and Vehicle Standards Agency officers and traffic officers and school crossing patrols.',
        <Entry>[
          new Entry('Police officers',
              'https://www.gov.uk/guidance/the-highway-code/signals-by-authorised-persons#policeofficers'),
          new Entry('Arm signals to persons controlling traffic',
              'https://www.gov.uk/guidance/the-highway-code/signals-by-authorised-persons#personscontrol'),
          new Entry(
              'Driver and Vehicle Standards Agency officers and traffic officers',
              'https://www.gov.uk/guidance/the-highway-code/signals-by-authorised-persons#dvsatrafficofficer'),
          new Entry('School crossing patrols',
              'https://www.gov.uk/guidance/the-highway-code/signals-by-authorised-persons#schoolcrosspatrols'),
        ],
      ),
      new Entry(
        'Traffic signs',
        '',
        'Traffic signs used, including signs giving orders, warning signs, direction signs, information signs and road works signs.',
        <Entry>[
          new Entry('Signs giving orders',
              'https://www.gov.uk/guidance/the-highway-code/traffic-signs#signsgivingorders'),
          new Entry('Warning signs',
              'https://www.gov.uk/guidance/the-highway-code/traffic-signs#warningsigns'),
          new Entry('Direction signs',
              'https://www.gov.uk/guidance/the-highway-code/traffic-signs#directionsigns'),
          new Entry('Information signs',
              'https://www.gov.uk/guidance/the-highway-code/traffic-signs#infosigns'),
          new Entry('Road works signs',
              'https://www.gov.uk/guidance/the-highway-code/traffic-signs#roadworksigns'),
        ],
      ),
      new Entry(
        'Road markings',
        '',
        'Road markings used, including those across the carriageway, along the carriageway, along the edge of the carriageway, on the kerb or at the edge of the carriageway and other road markings.',
        <Entry>[
          new Entry('Across the carriageway',
              'https://www.gov.uk/guidance/the-highway-code/road-markings#acrosscarriageway'),
          new Entry('Along the carriageway',
              'https://www.gov.uk/guidance/the-highway-code/road-markings#alongcarriageway'),
          new Entry('Along the edge of the carriageway',
              'https://www.gov.uk/guidance/the-highway-code/road-markings#edgecarriageway'),
          new Entry('On the kerb or at the edge of the carriageway',
              'https://www.gov.uk/guidance/the-highway-code/road-markings#kerbcarriageway'),
          new Entry('Other road markings',
              'https://www.gov.uk/guidance/the-highway-code/road-markings#otherroadmarkings'),
        ],
      ),
      new Entry(
        'Vehicle markings',
        '',
        'Vehicle markings used, including large goods vehicle rear markings, hazard warning plates, projection markers and other markings.',
        <Entry>[
          new Entry('Large goods vehicle rear markings',
              'https://www.gov.uk/guidance/the-highway-code/vehicle-markings#lgvrearmarkings'),
          new Entry('Hazard warning plates',
              'https://www.gov.uk/guidance/the-highway-code/vehicle-markings#hazardwarning'),
          new Entry('Projections markers',
              'https://www.gov.uk/guidance/the-highway-code/vehicle-markings#projectionmarkers'),
          new Entry('Other',
              'https://www.gov.uk/guidance/the-highway-code/vehicle-markings#schoolbus'),
        ],
      ),
      new Entry(
        'Annex 1. You and your bicycle.',
        '',
        'Information and rules about you and your bicycle.',
        <Entry>[
          new Entry('You and your bicycle',
              'https://www.gov.uk/guidance/the-highway-code/annex-1-you-and-your-bicycle#yourbicycle'),
        ],
      ),
      new Entry(
        'Annex 2. Motorcycle licence requirements',
        '',
        'Information and rules about motorcycle licence requirements.',
        <Entry>[
          new Entry('Motorcycle licence requirements',
              'https://www.gov.uk/guidance/the-highway-code/annex-2-motorcycle-licence-requirements#motorcyclelicence'),
          new Entry('Licence categories for mopeds and motorcycles',
              'https://www.gov.uk/guidance/the-highway-code/annex-2-motorcycle-licence-requirements#motorcyclecategory'),
        ],
      ),
      new Entry(
        'Annex 3. Motor vehicle documentation and learner driver requirements',
        '',
        'Information and rules about motor vehicle documentation and learner driver requirements.',
        <Entry>[
          new Entry('Documents',
              'https://www.gov.uk/guidance/the-highway-code/annex-3-motor-vehicle-documentation-and-learner-driver-requirements#documentation'),
          new Entry('Learner drivers',
              'https://www.gov.uk/guidance/the-highway-code/annex-3-motor-vehicle-documentation-and-learner-driver-requirements#learner-drivers'),
        ],
      ),
      new Entry(
        'Annex 4. The road user and the law',
        '',
        'Information about the road user and the law, including acts and regulations.',
        <Entry>[
          new Entry('Road traffic law',
              'https://www.gov.uk/guidance/the-highway-code/annex-4-the-road-user-and-the-law#abbrev'),
          new Entry('Acts and regulations prior to 1988',
              'https://www.gov.uk/guidance/the-highway-code/annex-4-the-road-user-and-the-law#acts-and-regulations-prior-to-1988'),
          new Entry('Acts and regulations from 1988 onwards',
              'https://www.gov.uk/guidance/the-highway-code/annex-4-the-road-user-and-the-law#acts-and-regulations-from-1988-onwards'),
        ],
      ),
      new Entry(
        'Annex 5. Penalties',
        '',
        'Information and rules about penalties, including points and disqualification, a penalty table, new drivers and other consequences of offending.',
        <Entry>[
          new Entry('Penalties and The Highway Code',
              'https://www.gov.uk/guidance/the-highway-code/annex-5-penalties#penaltyinfo'),
          new Entry('Penalty points and disqualification',
              'https://www.gov.uk/guidance/the-highway-code/annex-5-penalties#penalty-points-and-disqualification'),
          new Entry('Penalty table',
              'https://www.gov.uk/guidance/the-highway-code/annex-5-penalties#penaltytable'),
          new Entry('New drivers',
              'https://www.gov.uk/guidance/the-highway-code/annex-5-penalties#newdrivers'),
          new Entry('Other consequences of offending',
              'https://www.gov.uk/guidance/the-highway-code/annex-5-penalties#otherconseq'),
        ],
      ),
      new Entry(
        'Annex 6. Vehicle maintenance, safety and security',
        '',
        'Information and rules about vehicle maintenance, safety and security.',
        <Entry>[
          new Entry('Vehicle maintenance',
              'https://www.gov.uk/guidance/the-highway-code/annex-6-vehicle-maintenance-safety-and-security#vehiclemain'),
          new Entry('Vehicle security',
              'https://www.gov.uk/guidance/the-highway-code/annex-6-vehicle-maintenance-safety-and-security#vehiclesecure'),
        ],
      ),
      new Entry(
        'Annex 7. First aid on the road',
        '',
        'Information about first aid on the road, including dealing with danger, getting help, helping those involved, and providing emergency care.',
        <Entry>[
          new Entry('Deal with danger',
              'https://www.gov.uk/guidance/the-highway-code/annex-7-first-aid-on-the-road#deal'),
          new Entry('Get help',
              'https://www.gov.uk/guidance/the-highway-code/annex-7-first-aid-on-the-road#gethelp'),
          new Entry('Help those involved',
              'https://www.gov.uk/guidance/the-highway-code/annex-7-first-aid-on-the-road#helpinvolved'),
          new Entry('Provide emergency care',
              'https://www.gov.uk/guidance/the-highway-code/annex-7-first-aid-on-the-road#providecare'),
        ],
      ),
      new Entry(
        'Annex 8. Safety code for new drivers',
        '',
        'Information about the safety code for new drivers, including the New Drivers Act and further training.',
        <Entry>[
          new Entry('The safety code',
              'https://www.gov.uk/guidance/the-highway-code/annex-8-safety-code-for-new-drivers#safetycode'),
          new Entry('New Drivers Act',
              'https://www.gov.uk/guidance/the-highway-code/annex-8-safety-code-for-new-drivers#newdriversact'),
          new Entry('Further training',
              'https://www.gov.uk/guidance/the-highway-code/annex-8-safety-code-for-new-drivers#furthertraining'),
        ],
      ),
      new Entry(
        'Other information',
        '',
        'Metric conversions, useful websites, further reading, the blue badge scheme and code of practice horse-drawn vehicles.',
        <Entry>[
          new Entry('Metric conversions',
              'https://www.gov.uk/guidance/the-highway-code/other-information#metric'),
          new Entry('Useful websites',
              'https://www.gov.uk/guidance/the-highway-code/other-information#websites'),
          new Entry('Further reading',
              'https://www.gov.uk/guidance/the-highway-code/other-information#reading'),
        ],
      ),
      new Entry(
        'Index',
        '',
        'An A to Z index of topics covered by The Highway Code.',
        <Entry>[
          new Entry(
              'A', 'https://www.gov.uk/guidance/the-highway-code/index#a'),
          new Entry(
              'B', 'https://www.gov.uk/guidance/the-highway-code/index#b'),
          new Entry(
              'C', 'https://www.gov.uk/guidance/the-highway-code/index#c'),
          new Entry(
              'D', 'https://www.gov.uk/guidance/the-highway-code/index#d'),
          new Entry(
              'E', 'https://www.gov.uk/guidance/the-highway-code/index#e'),
          new Entry(
              'F', 'https://www.gov.uk/guidance/the-highway-code/index#f'),
          new Entry(
              'G', 'https://www.gov.uk/guidance/the-highway-code/index#g'),
          new Entry(
              'H', 'https://www.gov.uk/guidance/the-highway-code/index#h'),
          new Entry(
              'I', 'https://www.gov.uk/guidance/the-highway-code/index#i'),
          new Entry(
              'J', 'https://www.gov.uk/guidance/the-highway-code/index#j'),
          new Entry(
              'K', 'https://www.gov.uk/guidance/the-highway-code/index#k'),
          new Entry(
              'L', 'https://www.gov.uk/guidance/the-highway-code/index#l'),
          new Entry(
              'M', 'https://www.gov.uk/guidance/the-highway-code/index#m'),
          new Entry(
              'N', 'https://www.gov.uk/guidance/the-highway-code/index#n'),
          new Entry(
              'O', 'https://www.gov.uk/guidance/the-highway-code/index#o'),
          new Entry(
              'P', 'https://www.gov.uk/guidance/the-highway-code/index#p'),
          new Entry(
              'Q', 'https://www.gov.uk/guidance/the-highway-code/index#q'),
          new Entry(
              'R', 'https://www.gov.uk/guidance/the-highway-code/index#r'),
          new Entry(
              'S', 'https://www.gov.uk/guidance/the-highway-code/index#s'),
          new Entry(
              'T', 'https://www.gov.uk/guidance/the-highway-code/index#t'),
          new Entry(
              'U', 'https://www.gov.uk/guidance/the-highway-code/index#u'),
          new Entry(
              'V', 'https://www.gov.uk/guidance/the-highway-code/index#v'),
          new Entry(
              'W', 'https://www.gov.uk/guidance/the-highway-code/index#w'),
          new Entry(
              'X', 'https://www.gov.uk/guidance/the-highway-code/index#x'),
          new Entry(
              'Y', 'https://www.gov.uk/guidance/the-highway-code/index#y'),
          new Entry(
              'Z', 'https://www.gov.uk/guidance/the-highway-code/index#z'),
        ],
      ),
    ];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);
  final Entry entry;

  Widget _buildTiles(BuildContext context, Entry root) {
    if (root.children.isEmpty)
      return new ListTile(
        title: new Text(root.title),
        onTap: () => _handleURLButtonPress(context, root.links),
      );
    return new ExpansionTile(
      key: new PageStorageKey<String>(
          root.title), // root.title == newerRoot.title is true
      title: new Text(root.title),
      subtitle: new Text(root.subheading!),
      children:
          root.children.map((link) => _buildTiles(context, link)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(context, entry);
  }
}

void _handleURLButtonPress(BuildContext context, String url) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WebViewContainer(url, 'Highway Code')));
}

// void main() {
//   runApp(new ExpansionTileSample());
// }

import 'package:flutter/material.dart';
import 'package:maize_doc/Views/welcomepage.dart'; // Import your WelcomePage

class FarmingAdvicePage extends StatefulWidget {
  final String username;
  const FarmingAdvicePage({Key? key, required this.username}) : super(key: key);

  @override
  _FarmingAdvicePageState createState() => _FarmingAdvicePageState();
}

class _FarmingAdvicePageState extends State<FarmingAdvicePage> {
  String? selectedProvince;
  String? selectedDistrict;
  String farmingRegion = '';
  String farmingAdvice = '';

  final Map<String, List<String>> provincesAndDistricts = {
    'Mashonaland Central': ['Bindura', 'Guruve', 'Mazowe', 'Mbire', 'Mount Darwin', 'Muzarabani', 'Rushinga', 'Shamva'],
    'Manicaland': ['Mutare', 'Makoni', 'Buhera', 'Chipinge', 'Mutasa', 'Nyanga'],
    'Masvingo': ['Masvingo', 'Chiredzi', 'Bikita', 'Gutu', 'Mwenezi', 'Zaka'],
    'Mashonaland West': ['Chegutu', 'Hurungwe', 'Kariba', 'Makonde', 'Mhondoro-Ngezi', 'Sanyati', 'Zvimba'],
    'Mashonaland East': ['Chikomba', 'Goromonzi', 'Marondera', 'Mudzi', 'Murehwa', 'Mutoko', 'Seke', 'Uzumba-Maramba-Pfungwe', 'Wedza'],
    'Matabeleland North': ['Binga', 'Bubi', 'Hwange', 'Lupane', 'Nkayi', 'Tsholotsho', 'Umguza'],
    'Matabeleland South': ['Beitbridge', 'Bulilima', 'Gwanda', 'Insiza', 'Mangwe', 'Matobo', 'Umzingwane'],
    'Midlands': ['Chirumhanzu', 'Gokwe North', 'Gokwe South', 'Gweru', 'Kwekwe', 'Mberengwa', 'Shurugwi', 'Zvishavane'],
    'Harare': ['Harare', 'Chitungwiza', 'Epworth'],
    'Bulawayo': ['Bulawayo'],
  };

  void _updateFarmingRegion() {
    List<String> region1Districts = ['Chipinge', 'Mutasa', 'Mazowe'];
    List<String> region2Districts = ['Mutare', 'Makoni', 'Buhera', 'Nyanga'];
    List<String> region3Districts = ['Gweru', 'Kwekwe'];
    List<String> region4Districts = ['Bulawayo', 'Lupane', 'Binga', 'Hwange', 'Masvingo'];
    List<String> region5Districts = ['Chiredzi', 'Beitbridge'];

    if (region1Districts.contains(selectedDistrict)) {
      farmingRegion = 'Region 1';
      farmingAdvice = "Region 1 is suitable for maize and other cereals. Ensure proper soil preparation and use high-quality seeds.";
    } else if (region2Districts.contains(selectedDistrict)) {
      farmingRegion = 'Region 2';
      farmingAdvice = "Region 2 has good rainfall; focus on crop rotation and integrated pest management.";
    } else if (region3Districts.contains(selectedDistrict)) {
      farmingRegion = 'Region 3';
      farmingAdvice = "Region 3 is suitable for both maize and horticultural crops. Use irrigation where possible.";
    } else if (region4Districts.contains(selectedDistrict)) {
      farmingRegion = 'Region 4';
      farmingAdvice = "Region 4 is prone to drought; ensure proper water management and drought-resistant crops.";
    } else if (region5Districts.contains(selectedDistrict)) {
      farmingRegion = 'Region 5';
      farmingAdvice = "Region 5 is suitable for small grains and drought-resistant crops. Focus on soil conservation.";
    } else {
      farmingRegion = 'Unknown Region';
      farmingAdvice = '';
    }
  }

  void _refresh() {
    setState(() {
      selectedProvince = null;
      selectedDistrict = null;
      farmingRegion = '';
      farmingAdvice = '';
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage(username: widget.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farming Advice", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0DB14A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildLabel("Let Us Find Your Farming Region"),
            SizedBox(height: 8),
            _buildProvinceDropdown(),
            SizedBox(height: 0),
            if (selectedProvince != null) ...[
              _buildLabel("Select District"),
              SizedBox(height: 8),
              _buildDistrictDropdown(),
              SizedBox(height: 16),
            ],
            if (selectedDistrict != null) ...[
              _buildLabel("Farming Region"),
              SizedBox(height: 8),
              _buildFarmingRegionInfo(),
              SizedBox(height: 16),
            ],
            _buildMaizeFarmingAdviceTile(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'Refresh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            _navigateToHome(); // Navigate to Home
          } else if (index == 1) {
            _refresh(); // Refresh the page
          } else if (index == 2) {
            Navigator.pop(context); // Go back
          }
        },
      backgroundColor: Colors.green, // Set the background color
      selectedItemColor: Colors.white, // Set the selected item color
      unselectedItemColor: Colors.white70, // Set the unselected item color
    ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProvinceDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5)],
      ),
      child: DropdownButton<String>(
        hint: Center(child: const Text('Select Province')),
        value: selectedProvince,
        isExpanded: true,
        underline: SizedBox(), // Remove the underline
        onChanged: (String? newValue) {
          setState(() {
            selectedProvince = newValue;
            selectedDistrict = null; // Reset district when province changes
            farmingRegion = ''; // Reset farming region
            farmingAdvice = ''; // Reset farming advice
          });
        },
        items: provincesAndDistricts.keys.map<DropdownMenuItem<String>>((String province) {
          return DropdownMenuItem<String>(
            value: province,
            child: Center(child: Text(province)), // Center-align the province text
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDistrictDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 2, blurRadius: 5)],
      ),
      child: DropdownButton<String>(
        hint: Center(child: const Text('Select District')),
        value: selectedDistrict,
        isExpanded: true,
        underline: SizedBox(), // Remove the underline
        onChanged: (String? newValue) {
          setState(() {
            selectedDistrict = newValue;
            _updateFarmingRegion();
          });
        },
        items: provincesAndDistricts[selectedProvince]!.map<DropdownMenuItem<String>>((String district) {
          return DropdownMenuItem<String>(
            value: district,
            child: Center(child: Text(district)), // Center-align the district text
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFarmingRegionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          farmingRegion,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          farmingAdvice,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildMaizeFarmingAdviceTile() {
    return ExpansionTile(
      title: const Text(
        'Maize Farming Advice',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      children: [
        _buildAdviceExpansionTile(
          title: "Soil Preparation",
          advice: "Ensure that the soil is well-tilled and enriched with organic matter. Test the soil pH to ensure it is between 5.8 and 7.0 for optimal maize growth.",
        ),
        _buildAdviceExpansionTile(
          title: "Seed Selection",
          advice: "Choose high-quality seeds that are suited to your local climate. Look for drought-resistant and pest-resistant varieties.",
        ),
        _buildAdviceExpansionTile(
          title: "Planting",
          advice: "Plant maize seeds at a depth of 1-2 inches and ensure proper spacing between rows (30-36 inches) and within rows (8-12 inches).",
        ),
        _buildAdviceExpansionTile(
          title: "Watering",
          advice: "Maize requires adequate moisture, especially during the flowering stage. Ensure regular watering, particularly in dry spells.",
        ),
        _buildAdviceExpansionTile(
          title: "Fertilization",
          advice: "Use a balanced fertilizer with NPK (Nitrogen, Phosphorus, Potassium) to promote healthy growth. Apply fertilizers based on soil tests.",
        ),
        _buildAdviceExpansionTile(
          title: "Pest and Disease Management",
          advice: "Regularly monitor crops for pests and diseases. Use integrated pest management (IPM) practices to control infestations.",
        ),
        _buildAdviceExpansionTile(
          title: "Harvesting",
          advice: "Harvest maize when the kernels are firm and the husks are dry. Proper harvesting techniques can help reduce spoilage.",
        ),
      ],
    );
  }

  Widget _buildAdviceExpansionTile({required String title, required String advice}) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            advice,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
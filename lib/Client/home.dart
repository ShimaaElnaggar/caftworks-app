import 'package:flutter/material.dart';
import '../core/constants/app_theme.dart';
import 'post_request.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
  final List<Map<String, dynamic>> popularServices = [
    {
      'name': 'Sara Mohamed',
      'role': 'Baby setter',
      'rating': 4.7,
      'image': 'assets/images/imageboarding3.png',
    },
    {
      'name': 'Mahmoud Ali',
      'role': 'Electrician',
      'rating': 3.5,
      'image': 'assets/images/imageboarding3.png',
    },
        {
      'name': 'Sara Mohamed',
      'role': 'Baby setter',
      'rating': 4.7,
      'image': 'assets/images/imageboarding3.png',
    },
    {
      'name': 'Mahmoud Ali',
      'role': 'Electrician',
      'rating': 3.5,
      'image': 'assets/images/imageboarding3.png',
    },
        {
      'name': 'Sara Mohamed',
      'role': 'Baby setter',
      'rating': 4.7,
      'image': 'assets/images/imageboarding3.png',
    },
    {
      'name': 'Mahmoud Ali',
      'role': 'Electrician',
      'rating': 3.5,
      'image': 'assets/images/imageboarding3.png',
    },
  ];

  final List<Map<String, dynamic>> categories = [
  {'icon': Icons.construction, 'label': 'Carpenter'},
  {'icon': Icons.local_gas_station, 'label': 'Mechanic'},
  {'icon': Icons.home_repair_service, 'label': 'Technician'},
  {'icon': Icons.local_laundry_service, 'label': 'Laundry'},
  {'icon': Icons.grass, 'label': 'Gardener'},
  {'icon': Icons.format_paint, 'label': 'Painter'},
  {'icon': Icons.pest_control, 'label': 'Pest Control'},
  {'icon': Icons.lock, 'label': 'Locksmith'},
  {'icon': Icons.apartment, 'label': 'Mover'},
  {'icon': Icons.security, 'label': 'Security'},
];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          children: [
            const Text(
              'Hello, Marwa',
              style: TextStyle(fontSize: 18, color: AppColors.primary900Light),
            ),
            const Spacer(),
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary100Light, 
              child: Icon(Icons.face_2_rounded, color: AppColors.primaryLight),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: AppColors.backgroundLight,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary100Light,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Opacity(
                        opacity: 0.2,
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.percent,
                            size: 120, 
                            color: AppColors.primary700Light,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '20% Off on your\nfirst request!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary900Light,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Book now',
                            style: TextStyle(color: AppColors.primaryForegroundLight),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

             
              const Text(
                'Popular',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary900Light),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularServices.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final service = popularServices[index];
                    return Container(
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.cardLight,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mutedLight.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              service['image'],
                              height: 100,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.primary900Light,
                                  ),
                                ),
                                Text(
                                  service['role'],
                                  style: const TextStyle(
                                    color: AppColors.mutedForegroundLight,
                                    fontSize: 12,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: AppColors.warningLight, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      service['rating'].toString(),
                                      style: const TextStyle(fontSize: 13, color: AppColors.primary900Light),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
         
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                 color: AppColors.primary900Light),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Container(
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.primary600,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mutedLight.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary100Light,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(cat['icon'], size: 28, color: AppColors.primaryLight),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cat['label'],
                            style: const TextStyle(fontSize: 12, color: AppColors.primary900Light),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostRequestPage()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.mutedForegroundLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryLight, 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryLight,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.add,
                size: 36,
                color: AppColors.primaryForegroundLight, 
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardLight,
      ),
    );
  }
}


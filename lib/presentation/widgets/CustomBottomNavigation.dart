import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 2; // Mặc định chọn nút thứ 3 (vương miện) giống mẫu

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Biểu tượng ngôi nhà (vị trí 1)
          _buildNavItem(
            index: 0,
            svgPath: '''
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M3 9L12 2L21 9V20C21 20.5304 20.7893 21.0391 20.4142 21.4142C20.0391 21.7893 19.5304 22 19 22H5C4.46957 22 3.96086 21.7893 3.58579 21.4142C3.21071 21.0391 3 20.5304 3 20V9Z" stroke="${_selectedIndex == 0 ? '#042628' : '#97A2B0'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 22V12H15V22" stroke="${_selectedIndex == 0 ? '#042628' : '#97A2B0'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            ''',
          ),

          // Biểu tượng kính lúp (vị trí 2)
          _buildNavItem(
            index: 1,
            svgPath: '''
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M11 19C15.4183 19 19 15.4183 19 11C19 6.58172 15.4183 3 11 3C6.58172 3 3 6.58172 3 11C3 15.4183 6.58172 19 11 19Z" stroke="${_selectedIndex == 1 ? '#042628' : '#97A2B0'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M21 21L16.65 16.65" stroke="${_selectedIndex == 1 ? '#042628' : '#97A2B0'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            ''',
          ),

          // Biểu tượng vương miện (vị trí 3, nằm trong vòng tròn lớn)
          _buildNavItem(
            index: 2,
            svgPath: '''
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M221.669 60.6763V62.9701C221.669 65.1328 221.669 66.2141 222.341 66.886C223.013 67.5578 224.094 67.5578 226.257 67.5578H229.315C231.478 67.5578 232.559 67.5578 233.231 66.886C233.903 66.2141 233.903 65.1328 233.903 62.9701V60.6763" stroke="${_selectedIndex == 2 ? '#FFFFFF' : '#97A2B0'}" stroke-width="1.5" stroke-linecap="round"/>
                <path d="M221.669 60.6129C219.499 60.2489 217.846 58.3619 217.846 56.0887C217.846 53.555 219.9 51.501 222.434 51.501C222.748 51.501 223.056 51.5327 223.353 51.5931" stroke="${_selectedIndex == 2 ? '#FFFFFF' : '#97A2B0'}" stroke-width="1.5" stroke-linecap="round"/>
                <path d="M234.057 60.6129C236.227 60.2489 237.881 58.3619 237.881 56.0887C237.881 53.555 235.827 51.501 233.293 51.501C232.978 51.501 232.671 51.5327 232.374 51.5931" stroke="${_selectedIndex == 2 ? '#FFFFFF' : '#97A2B0'}" stroke-width="1.5" stroke-linecap="round"/>
                <path d="M223.343 54.177C223.248 53.8104 223.198 53.4261 223.198 53.0301C223.198 50.4964 225.252 48.4424 227.786 48.4424C230.32 48.4424 232.374 50.4964 232.374 53.0301C232.374 53.4261 232.323 53.8104 232.229 54.177" stroke="${_selectedIndex == 2 ? '#FFFFFF' : '#97A2B0'}" stroke-width="1.5" stroke-linecap="round"/>
                <path d="M221.669 64.1172H233.903" stroke="${_selectedIndex == 2 ? '#FFFFFF' : '#97A2B0'}" stroke-width="1.5"/>
                <path d="M227.756 56.7329V59.1355" stroke="${_selectedIndex == 2 ? '#FFFFFF' : '#97A2B0'}" stroke-width="1.5" stroke-linecap="round"/>
                <path d="M223.507 56.9343C223.315 57.3633 223.667 58.9989 224.083 59.267" stroke="${_selectedIndex == 2 ? '#FFFFFF' : '#97A2B0'}" stroke-width="1.5" stroke-linecap="round"/>
                <path d="M232.32 56.9343C232.512 57.3633 232.16 58.9989 231.744 59.267" stroke="${_selectedIndex == 2 ? '#FFFFFF' : '#97A2B0'}" stroke-width="1.5" stroke-linecap="round"/>
              </svg>
            ''',
            isCenter: true, // Nút giữa có vòng tròn lớn
          ),

          // Biểu tượng chuông (vị trí 4)
          _buildNavItem(
            index: 3,
            svgPath: '''
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M18 8C18 6.4087 17.3679 4.88258 16.2426 3.75736C15.1174 2.63214 13.5913 2 12 2C10.4087 2 8.88258 2.63214 7.75736 3.75736C6.63214 4.88258 6 6.4087 6 8C6 15 3 17 3 17H21C21 17 18 15 18 8Z" stroke="${_selectedIndex == 3 ? '#042628' : '#97A2B0'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M13.73 21C13.5542 21.3031 13.3019 21.5547 12.9982 21.7295C12.6946 21.9042 12.3504 21.9965 12 21.9965C11.6496 21.9965 11.3054 21.9042 11.0018 21.7295C10.6981 21.5547 10.4458 21.3031 10.27 21" stroke="${_selectedIndex == 3 ? '#042628' : '#97A2B0'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            ''',
          ),

          // Biểu tượng người dùng (vị trí 5)
          _buildNavItem(
            index: 4,
            svgPath: '''
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M20 21V19C20 17.9391 19.5786 16.9217 18.8284 16.1716C18.0783 15.4214 17.0609 15 16 15H8C6.93913 15 5.92172 15.4214 5.17157 16.1716C4.42143 16.9217 4 17.9391 4 19V21" stroke="${_selectedIndex == 4 ? '#042628' : '#97A2B0'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M12 11C14.2091 11 16 9.20914 16 7C16 4.79086 14.2091 3 12 3C9.79086 3 8 4.79086 8 7C8 9.20914 9.79086 11 12 11Z" stroke="${_selectedIndex == 4 ? '#042628' : '#97A2B0'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String svgPath,
    bool isCenter = false,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected && isCenter ? const Color(0xFF042628) : Colors.transparent,
        ),
        child: SvgPicture.string(
          svgPath,
          width: isCenter ? 40 : 24, // Kích thước lớn hơn cho nút giữa
          height: isCenter ? 40 : 24,
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class CustomShapeWidget extends StatelessWidget {
//   final double width;
//   final double height;
//   final Color? backgroundColor;
//
//   const CustomShapeWidget({
//     Key? key,
//     this.width = 455,
//     this.height = 175,
//     this.backgroundColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       height: height,
//       child: SvgPicture.string(
//         '''
// <svg width="455" height="175" viewBox="0 0 455 175" fill="none" xmlns="http://www.w3.org/2000/svg">
// <g filter="url(#filter0_d_1218_5727)">
// <path d="M40 82C40 70.9543 48.9543 62 60 62H176.004C182.513 62 188.076 63.8894 191.949 69.1201C199.903 79.8596 206.557 95 227.5 95C248.481 95 255.75 79.8049 263.985 69.062C267.945 63.8962 273.487 62 279.996 62H395C406.046 62 415 70.9543 415 82V145H40V82Z" fill="white"/>
// </g>
// <path d="M75.1437 103.782V100.715C75.1437 99.9381 75.7757 99.3067 76.5584 99.3018H79.4326C80.2189 99.3018 80.8563 99.9346 80.8563 100.715V100.715V103.773C80.8563 104.447 81.404 104.995 82.0829 105H84.0438C84.9596 105.002 85.8388 104.643 86.4872 104.001C87.1356 103.359 87.5 102.487 87.5 101.578V92.8658C87.5 92.1314 87.1721 91.4347 86.6046 90.9635L79.943 85.6743C78.7785 84.7491 77.1154 84.779 75.9854 85.7454L69.467 90.9635C68.8727 91.4208 68.5176 92.1196 68.5 92.8658V101.569C68.5 103.464 70.0474 105 71.9562 105H73.8723C74.1992 105.002 74.5135 104.875 74.7455 104.646C74.9775 104.418 75.1079 104.107 75.1079 103.782H75.1437Z" fill="#70B9BE"/>
// <path fill-rule="evenodd" clip-rule="evenodd" d="M74.3406 94.8896C74.3406 94.4754 74.6764 94.1396 75.0906 94.1396H80.9098C81.324 94.1396 81.6598 94.4754 81.6598 94.8896C81.6598 95.3039 81.324 95.6396 80.9098 95.6396H75.0906C74.6764 95.6396 74.3406 95.3039 74.3406 94.8896Z" fill="#C6E3E5"/>
// <circle cx="153.767" cy="93.7666" r="8.98856" stroke="#97A2B0" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
// <path d="M160.018 100.485L163.542 104" stroke="#97A2B0" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
// <path fill-rule="evenodd" clip-rule="evenodd" d="M301 99.8476C306.639 99.8476 309.248 99.1242 309.5 96.2205C309.5 93.3188 307.681 93.5054 307.681 89.9451C307.681 87.1641 305.045 84 301 84C296.955 84 294.319 87.1641 294.319 89.9451C294.319 93.5054 292.5 93.3188 292.5 96.2205C292.753 99.1352 295.362 99.8476 301 99.8476Z" stroke="#97A2B0" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
// <path d="M303.389 102.857C302.025 104.372 299.897 104.39 298.519 102.857" stroke="#97A2B0" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
// <path fill-rule="evenodd" clip-rule="evenodd" d="M376.848 97.3462C372.98 97.3462 369.677 97.931 369.677 100.273C369.677 102.615 372.959 103.22 376.848 103.22C380.716 103.22 384.017 102.635 384.017 100.294C384.017 97.9529 380.737 97.3462 376.848 97.3462Z" stroke="#97A2B0" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
// <path fill-rule="evenodd" clip-rule="evenodd" d="M376.848 94.0059C379.386 94.0059 381.443 91.9478 381.443 89.4097C381.443 86.8716 379.386 84.8145 376.848 84.8145C374.31 84.8145 372.252 86.8716 372.252 89.4097C372.243 91.9392 374.287 93.9973 376.816 94.0059H376.848Z" stroke="#97A2B0" stroke-width="1.42857" stroke-linecap="round" stroke-linejoin="round"/>
// <g filter="url(#filter1_d_1218_5727)">
// <circle cx="227.863" cy="58" r="28" fill="#042628"/>
// </g>
// <path d="M221.669 60.6763V62.9701C221.669 65.1328 221.669 66.2141 222.341 66.886C223.013 67.5578 224.094 67.5578 226.257 67.5578H229.315C231.478 67.5578 232.559 67.5578 233.231 66.886C233.903 66.2141 233.903 65.1328 233.903 62.9701V60.6763" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
// <path d="M221.669 60.6129C219.499 60.2489 217.846 58.3619 217.846 56.0887C217.846 53.555 219.9 51.501 222.434 51.501C222.748 51.501 223.056 51.5327 223.353 51.5931" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
// <path d="M234.057 60.6129C236.227 60.2489 237.881 58.3619 237.881 56.0887C237.881 53.555 235.827 51.501 233.293 51.501C232.978 51.501 232.671 51.5327 232.374 51.5931" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
// <path d="M223.343 54.177C223.248 53.8104 223.198 53.4261 223.198 53.0301C223.198 50.4964 225.252 48.4424 227.786 48.4424C230.32 48.4424 232.374 50.4964 232.374 53.0301C232.374 53.4261 232.323 53.8104 232.229 54.177" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
// <path d="M221.669 64.1172H233.903" stroke="white" stroke-width="1.5"/>
// <path d="M227.756 56.7329V59.1355" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
// <path d="M223.507 56.9343C223.315 57.3633 223.667 58.9989 224.083 59.267" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
// <path d="M232.32 56.9343C232.512 57.3633 232.16 58.9989 231.744 59.267" stroke="white" stroke-width="1.5" stroke-linecap="round"/>
// <defs>
// <filter id="filter0_d_1218_5727" x="0" y="12" width="455" height="163" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
// <feFlood flood-opacity="0" result="BackgroundImageFix"/>
// <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
// <feOffset dy="-10"/>
// <feGaussianBlur stdDeviation="20"/>
// <feColorMatrix type="matrix" values="0 0 0 0 0.584583 0 0 0 0 0.660451 0 0 0 0 0.766667 0 0 0 0.15 0"/>
// <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_1218_5727"/>
// <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_1218_5727" result="shape"/>
// </filter>
// <filter id="filter1_d_1218_5727" x="169.863" y="0" width="116" height="116" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
// <feFlood flood-opacity="0" result="BackgroundImageFix"/>
// <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
// <feOffset/>
// <feGaussianBlur stdDeviation="15"/>
// <feColorMatrix type="matrix" values="0 0 0 0 0.0117647 0 0 0 0 0.0117647 0 0 0 0 0.0980392 0 0 0 0.2 0"/>
// <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_1218_5727"/>
// <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_1218_5727" result="shape"/>
// </filter>
// </defs>
// </svg>
//
//         ''',
//         fit: BoxFit.contain,
//       ),
//     );
//   }
// }
//
// // Extension để chuyển Color sang mã hex
// extension ColorExtension on Color {
//   String toHex() {
//     return '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
//   }
// }
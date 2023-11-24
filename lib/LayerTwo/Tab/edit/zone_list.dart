import 'package:flutter/material.dart';

class ZoneList extends StatelessWidget {
  final List<String> zones;
  final Map<String, String> zoneInfo = {
    'Zone A':
        'Bandar Baru Salak, Jijan, Kota Seri Mas, Kota Warisan, Nilai, Nilai 3, Nilai Impian, Labu, LBJ, PCH Pajam, Semenyih, Seremban, Seremban 3, Linggi, Mambau, Port Dickson, Port Dickson Bt 11, Port Dickson Bt 9, Rantau, Seri Menanti, Mantin, Paroi, Beranang, Sendayan, Batang Benar, Lukut, Senawang, Paya Indah, Pekan Salak, Bagan Lalang, Dengkil, Taman Baiduri, Sepang, Jenderam, Sungai Pelek, Hulu Langat, Taman Bistari, Gold Coast, Sepang.',
    'Zone B':
        'Bandar Baru Bangi, Banting, Jenjarum, Jugra, Banting, Kuala Langat, Bukit Changgang, Bukit Mahkota, Cyberjaya, Pekan Lama Bangi, Putrajaya, Serdang, Serdang Raya, MARDI, Serdang, Bandar Tasik Selatan, Bukit Jalil, Bukit Kajang, Bukit Serdang, Seri Kembangan, Prima Saujana Kajang, Puncak Jalil, Country Heights Kajang, South City Plaza, Sri Petaling, Desa Petaling, Balakong, Happy Garden, Sungai Besi, Taming Jaya, Taman Seri Indah, Taman Sg Besi Indah, Taman Tasik Selatan, Kajang Impian, Kajang Mewah, Kajang Perdana, Kajang Prima, Kajang Saujana, Sri Serdang.',
    'Zone C':
        'Bandar Bukit Puchong, Bandar Puchong, Bandar Puteri Puchong, Putra Height, Jln Puchong Bt 6-12, Puchong Hartamas, Puchong Jaya, Puchong Perdana, Puchong Permai, Puchong Prima, Puchong Utama, Sri Subang, Subang Airport, Subang Hi-Tech, Subang Indah, Subang Perdana, Sungai Chua, Sungai Way, Sunway Subang, Saujana Hyatt, Bandar Sunway, Kampung Lindungan, Subang Jaya 10-19, USJ, Batu 3, Shah Alam, Bukit Rimau, Glenmarie, Lembah Subang, Padang Jawa, Kota Kemuning, Shah Alam, Shah Alam 30-34, TUDM Subang, Batu Belah, Klang, Bandar Puteri, Klang, Bukit Jelutong U8, Bukit Raja, Bukit Subang, Bukit Tinggi, Klang, Kg Jawa, Kg Melayu, Klang Sentral, Meru Bt 2-8, Pulau Carey, Taman Andalas, Taman Botanica, Klang, Taman Sentosa, Klang, U4 9-15, Aman Perdana Klang, Bandar Klang, Shah Alam U10, Shah Alam U11, Shah Alam U13, Shah Alam U5, Shah Alam U9, Bukit Bayu, Denai Alam, Kayangan Heights, Pekan Meru, Pinggiran Subang, Setia Alam, Subang 2, Subang Mah Sing, Sunway Alam Suria, Cahaya SPK, Kapar Bt 2-9, Pekan Kapar, Kapar, Klang, Pandamaran, Port Klang, Pulau Indah, UiTM Puncak Perdana, Puncak Alam, TTDI Jaya.',
    'Zone D':
        'Kelana Jaya, PJS 1-6, Aman Suria, Ara Damansara, Bandar Utama, Casa Damansara, Damansara Indah, Damansara Jaya, Damansara Utama, Federal Hill, Bukit Damansara Jalan Gasing, Jln Klang Lama, Kampung Medan, Kayu Ara, One Utama, Petaling Jaya 16-26, SS 2, Bangsar Taman Dato Harun, Taman Mayang, Taman Medan, Damansara Heights, Damansara Indah, Damansara Intan, Damansara Perdana, Damansara Permai, Tiara Damansara, TTDI, Mont Kiara, Solaris Mont Kiara, Sri Hartamas, Casa Indah, IKEA Damansara, Kota Damansara, Mutiara Damansara, Pelangi Damansara, Sunway Damansara, The Curve, Bukit Lanjan, Tropicana Damansara.',
    'Zone E':
        'US Embassy, Taman Desa, Jln Kuchai Lama, Pantai Dalam, Pantai Hill Park, Alam Damai, Bandar Baru Sentul, Bandar Mahkota, Bandar Permaisuri, Bandar Tun Razak, Taman OUG, Taman Salak Jaya, Bdr Sg Long, Bdr Tun Hussein Onn, Bukit Ampang, Bukit Bintang, Bukit Tunku, Cheras Batu 9-11, Cheras Hartamas, Cheras Indah, Cheras Jaya, Cheras Mewah, Cheras Perdana, Cheras Permai, Damai Jaya, Damai Perdana, Danau Desa, Desa Aman, Desa Angkasa, Desa Tasik, Hotel Corus, Hotel Mandarin, Hotel Nikko, HUKM, IKEA Cheras, Jalan Duta, Jalan Ipoh, Jalan Kuching, Jalan Pahang, Jalan Sentul, Jalan Ulu Klang, Kenny Hills, Kg Pandan, KL Sentral, KLCC, Lake Damai, Mid Valley, Pandan Indah, Pandan Jaya, Pandan Perdana, Suntex Garden, Taman Maluri, Taman Bukit Indah, Taman Cahaya, Taman Cempaka, Taman Cheras, Taman Duta, Taman Kesuma, Taman Maluri, Cheras, Taman Mega, Cheras, Taman Midah, Cheras, Taman Mulia, Cheras, Taman Segar, Taman Segar Perdana, Taman Seputeh, The Peak.',
    'Zone F':
        'Ampang Hilir, Ampang Jaya, Ampang Park, Ampang Point, Lembah Jaya Selatan, Lembah Jaya Utara, Keramat AU, Danau Kota, Dataran Ukays, Bukit Antarabangsa, Datuk Keramat, Desa Setapak, Jalan Ampang, Jalan Genting Klang, Jalan Jelatek, Segambut, Kolej TAR, Setapak Jaya, Setiawangsa, Taman Bukit Maluri Taman Ibu Kota Taman Setapak, Wangsa Maju, Wangsa Permai, Ukay Perdana, Taman Permata, Zoo View.',
    'Zone G':
        'Batu Caves, Damansara Damai, Desa Aman Puri, Desa Park City, Gombak, Gombak Setia, Greenwood, Jln Gombak Bt 3-10, Kepong Baru, Penjara Sg Buloh, Rahman Putra, Sg Buloh, Saujana Utama, Sieramas, Sri Damansara, Sungai Pusu, Sunway SPK, Taman Ehsan, Taman Kepong, Taman Koperasi Polis, Taman Melati, Taman Melawati, Taman Melewar, Taman Perwira, Taman Samudera, Taman Sri Gombak, Bdr Baru Selayang, Intan Baiduri, UIA Gombak.',
    'Zone H': 'Desa Coalfield, Ijok, Jeram, Kuang, Taman Bidara, Taman Idaman.',
    'Zone I':
        'Bandar Tasik Puteri, Country Homes, Rawang, Serendah, Tasik Puteri, Ulu Yam, Bukit Rasa, Lembah Beringin, Batang Kali, Kuala Selangor, Ulu Bernam, Bukit Beruntung, Batu Arang, Kerling, Templer Park.',
    'Zone J':
        'Alor Gajah, A Famosa, Ayer Keroh, Ayer Molek, Batu Berendam, Masjid Tanah, Melaka.',
    'Zone K': 'Other States.',
    'Zone L': 'Oversea.',
  };

  ZoneList({super.key, required this.zones, required TextStyle style});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: zones.length,
      itemBuilder: (context, index) {
        final zone = zones[index];
        final zoneDescription = zoneInfo[zone] ?? 'No information available';

        return ListTile(
          title: Text(zone),
          onTap: () {
            _showZoneInfo(context, zone, zoneDescription);
          },
        );
      },
    );
  }

  void _showZoneInfo(BuildContext context, String zone, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(zone, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text(description),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white, fontFamily: 'Futura'),
                )),
          ],
        );
      },
    );
  }
}

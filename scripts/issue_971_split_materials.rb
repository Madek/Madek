# Issue #971: split media_content:portrayed_object_materials into new keyword meta keys
#
# Dry run (rolls back):  cd webapp && DRY_RUN=true bin/rails runner ../scripts/issue_971_split_materials.rb
# Apply:                 cd webapp && bin/rails runner ../scripts/issue_971_split_materials.rb
#
# Creates the new meta keys, adds them to every context containing SOURCE (right
# after it), moves the keywords listed in MAPPING together with their assignments,
# deletes SOURCE meta data left empty by the move and relabels SOURCE.

require 'csv'

SOURCE = 'media_content:portrayed_object_materials'
SOURCE_LABELS = { 'de' => 'Material', 'en' => 'Material' }

NEW_META_KEYS = {
  'media_content:languages' => { 'de' => 'Sprache', 'en' => 'Language' },
  'media_content:recording_medium' => { 'de' => 'Aufnahmemedium', 'en' => 'Recording medium' },
  'media_content:audio_formats' => { 'de' => 'Audioformat', 'en' => 'Audio format' },
  'media_content:video_formats' => { 'de' => 'Videoformat', 'en' => 'Video format' },
  'media_content:image_size' => { 'de' => 'Bildgrösse', 'en' => 'Image size' },
  'media_content:aspect_ratio' => { 'de' => 'Seitenverhältnis', 'en' => 'Aspect ratio' },
  'media_content:work_type' => { 'de' => 'Werktyp', 'en' => 'Work type' }
}

# assignment list from issue #971 (zuweisung_971_mat-format-sprache.csv), rows not staying in SOURCE
MAPPING = CSV.parse(<<~'CSV', col_sep: ';', headers: true).map(&:to_h)
keyword_id;term;meta_key_id
24d6d6b4-167e-4eab-959c-7c21263bf4b3;1.55:1;media_content:aspect_ratio
132fc5f2-6734-469b-af50-628c09c8f1a0;1.5:1;media_content:aspect_ratio
3fc4f683-af7c-4956-ae91-950e6ef29bee;1.60:1;media_content:aspect_ratio
06751b9a-7bcd-495a-b425-9aebbef768dd;1.78;media_content:aspect_ratio
eee494a4-972f-42e4-9374-951d00f823ab;1.85:1;media_content:aspect_ratio
74f1f18e-7ca2-4493-b512-ad7e533e98e4;16:9;media_content:aspect_ratio
4df5efca-16a4-4769-b8a4-4565a57edb0e;2.39:1;media_content:aspect_ratio
3cb3566a-c190-4c70-98e4-0b8995c67b57;9:16;media_content:aspect_ratio
f5ab83a3-4f7b-4ec9-96ce-b47435962421;cinemascope;media_content:aspect_ratio
45ec6939-c7e5-4dc7-817b-83203246749e;Scope 2.39:1;media_content:aspect_ratio
8365d699-52a8-4daf-8378-49e0ff8056b6;Seitenverhältnis 1.42:1;media_content:aspect_ratio
4af73cee-14a6-44d5-9848-79c22cafdc1d;Seitenverhältnis 1.66:1;media_content:aspect_ratio
70ce97f9-d217-4d36-8a4a-f86e8d737fce;Seitenverhältnis 16:9;media_content:aspect_ratio
1e3b2d14-68a5-4341-b91f-9269332e007e;Seitenverhältnis 1:1;media_content:aspect_ratio
65cb846b-16a9-49a3-b79e-4259358b3e9c;Seitenverhältnis 1:1.33;media_content:aspect_ratio
85fbd4d1-46e4-4a8d-b69b-cdb36d23e0e6;Seitenverhältnis 1:1.78 (16:9);media_content:aspect_ratio
248502e0-9da3-400c-ae66-8714c918f23c;Seitenverhältnis 1:1.85;media_content:aspect_ratio
854a1b7a-e1ad-4921-bd08-5a08dc42c303;Seitenverhältnis 1:2.35;media_content:aspect_ratio
88739ed8-2580-4e5a-8fd5-6da20c39ed56;Seitenverhältnis 1:2.39;media_content:aspect_ratio
72d2cf48-8588-4f0e-9448-7b176ba46db1;Seitenverhältnis 2:1;media_content:aspect_ratio
258552d2-6d0d-44a5-aac2-b39a6aea7ad9;Seitenverhältnis: 1.437:1;media_content:aspect_ratio
5dfbefee-c7a8-4c6a-a05a-e74ba4f1f853;Vorführformat: 1.9:1;media_content:aspect_ratio
80c906da-6b50-4ced-b70b-54bd399b8cca;5:1 Dolby;media_content:audio_formats
c773dd36-37d3-4118-b93c-a8aa7c0f9eb7;8-Kanal Audio;media_content:audio_formats
f8b7a0f7-4595-4392-a855-5e2a36cc5ee3;Ambisonics, BFormat;media_content:audio_formats
7195f5ec-8b7d-4db9-b375-9e501138ff64;Auro-3D;media_content:audio_formats
5f65a6e6-1871-4513-a04c-28d413d15897;Dolby Atmos;media_content:audio_formats
0597d983-fb47-4fa7-a1ba-5fca00009393;m4a;media_content:audio_formats
a85f1338-73a3-4fcf-82c1-674cb7fcb3c9;MP3;media_content:audio_formats
e5c33248-e043-4142-9473-95765fdb730c;Sepmag;media_content:audio_formats
bbbcabc9-7302-49eb-9d67-f81de753094d;Stereo;media_content:audio_formats
adb4e081-da6c-4091-9691-731e47fc9f3f;Surround 5.1;media_content:audio_formats
ae5d7f5c-e400-468b-a537-f861079cc5d6;Surround 7.1;media_content:audio_formats
c39fc2d1-e0fb-4bdc-9784-8046143e12bb;Ton Dolby SR;media_content:audio_formats
e12d1f53-93cf-4733-9b64-626fa8d7e7e8;Ton Mono;media_content:audio_formats
658b1601-8347-4822-8d50-5a606444a7c5;Ton Stereo +6.0;media_content:audio_formats
8c53218a-39e6-4df9-a2ce-920b2829c849;Ton Stereo, 5.1;media_content:audio_formats
031647d3-fa91-486c-a0d0-ee96aed55a8c;Vorführformat: Lichtton;media_content:audio_formats
38604d7b-bd90-42c5-b1a2-5b0a59921cd6;WAV;media_content:audio_formats
8adf7b1f-cdfa-4cab-9d44-4a85bdf683b0;2K;media_content:image_size
979e2789-7462-499c-b4cd-f1943ea5a0d5;4K;media_content:image_size
929f1db1-5876-4a3e-8424-44dfae3a1bcd;5K;media_content:image_size
8e85af41-ad2b-482d-bf95-22c1c2762328;HD;media_content:image_size
8339f1f1-b438-471e-9ade-55da10c73cc8;HDTV 1080p;media_content:image_size
a4174f0a-57fb-48a0-84e5-be6dff92061c;HDV 1080i50;media_content:image_size
83f300f5-633d-4dcd-a6e2-47daf95d6e22;Pal;media_content:image_size
8a828337-d079-4e37-bfcd-acdbea983954;Video 4K UHD;media_content:image_size
49054994-869a-4a54-b378-31ea001c0c38;Video HD 1080i;media_content:image_size
3e959fd8-71bb-444b-949b-5f2575df1996;Video HD 1080p;media_content:image_size
d6f42025-2bff-45d0-97a3-0a3a96c6c659;Albanisch;media_content:languages
8cfa0ddb-3385-4b5c-aefe-9e218c025cd2;Arabisch;media_content:languages
0d180282-29b8-4205-85b1-007f1750bc05;Bosnisch;media_content:languages
cd9e3217-fc0d-4e2c-8016-2810ce4b2a87;Cofán;media_content:languages
9bc0a40f-ee5c-4214-a84e-7e4e6d7dd27f;Deutsch;media_content:languages
51c95bb2-76b6-4249-acbd-027659cefa26;Englisch;media_content:languages
641e781f-ff3e-4eae-afe2-4c4044b20e1c;english;media_content:languages
4f725f19-782a-4760-82d2-43d2edb282ff;Finnisch;media_content:languages
8429cbce-78dd-4298-b22d-68eb478e1aa3;Französisch;media_content:languages
b0b5e33b-b02b-4332-8901-88e58acb48b5;Hebräisch;media_content:languages
e3d9a247-401f-46e8-aae9-c85474995417;Indonesisch;media_content:languages
6970d7aa-8a9c-4158-baf9-a6b4148d96c7;Italienisch;media_content:languages
33fc3158-fd0b-4bdc-8702-d39276142ee1;Jamaican Patois;media_content:languages
f21e1d17-6d6a-4ddf-9fc6-2c12c50c7b12;Japanisch;media_content:languages
2815a9eb-e371-4721-a5d6-6cd86d1084b0;Koreanisch;media_content:languages
9cdb58be-b765-4815-8cd9-a0465b8eec30;Language: German, Swiss German, French;media_content:languages
f32640f5-d452-414a-bbc6-66768e2efb96;Malayalam;media_content:languages
bfcb4eae-75be-43bc-8489-2fe63e80dc5d;Niederländisch;media_content:languages
5c64a18a-1f00-4db6-aaaa-ea9914c80b4c;ohne Dialog;media_content:languages
98e9cade-d921-4857-9a84-82da4dbdbfde;Onomatopoetisch;media_content:languages
8fe62636-b290-4ffd-9f63-a8691471d4fd;original version: russian;media_content:languages
ddde6f78-c00c-4b9b-8ac1-cdc5f7f36f60;Persisch;media_content:languages
94c04f99-20d5-4501-acaf-5a044439fe38;Portugiesisch;media_content:languages
97442bfe-a2be-4371-846d-fd46ba639722;Romanisch;media_content:languages
be9565be-9790-459b-bede-a064a52e686f;Rumänisch;media_content:languages
b2669a91-99be-4233-9c62-9edba93b51fe;Russisch;media_content:languages
5b508bbc-e6a9-4c1f-9d2c-96650d8465f6;Schwe;media_content:languages
963949c5-2d27-4806-af54-80773b194094;Schweizerdeutsch;media_content:languages
9678a2e3-08c2-4d3b-9701-4c3922b0664c;Slowakisch;media_content:languages
f6a38e84-6152-40c4-8eec-c33c07758913;Spanisch;media_content:languages
5845a746-c18e-4d08-8da4-346072a6d872;Sprache Albanisch;media_content:languages
7df7c54a-ac81-4158-82ad-63abcf4579ef;Sprache Arabisch;media_content:languages
8ff4739f-9865-4d24-9096-929d98d29344;Sprache Berber;media_content:languages
b24d2d15-d678-4cf6-b73f-948ae9033114;Sprache Deutsch;media_content:languages
763ec6f9-8b53-4108-9dd1-1363363a5d82;Sprache Engl;media_content:languages
38893ad2-4060-4ee0-8e13-065cee38c8b0;Sprache Englisch;media_content:languages
04343b99-351e-4048-b29b-a2261b36409a;Sprache Farsi;media_content:languages
688f7bb9-5ac3-4337-a034-e86a8342ccfe;Sprache Französisch;media_content:languages
0748e1fb-4c74-4272-bc6f-db74c68feb50;Sprache Gujarati;media_content:languages
db4aa4ad-b0d8-413c-8cd8-a5d3c083b546;Sprache Hindi;media_content:languages
33cb2497-4462-4358-9101-0cb9bd34efe2;Sprache Italienisch;media_content:languages
41482313-6d47-4268-a53f-81b07e751fc7;Sprache Koreanisch;media_content:languages
08dabf98-22a6-4a77-ac01-f68de74b5a28;Sprache Kurdisch;media_content:languages
a3d702ec-e13f-4487-b0cc-e194903008a5;Sprache Moldawisch;media_content:languages
26449d6e-6c2e-45c0-b20b-c8ec8abbd1e2;Sprache Polnisch;media_content:languages
b4ea7579-bcc1-4208-9770-09ea35c0944b;Sprache Portugiesisch;media_content:languages
497fb716-92bb-4919-8c3c-bafefda90346;Sprache Russisch;media_content:languages
684c9b24-6d3e-46e6-a5b2-7ee9c5039ec4;Sprache Schweizerdeutsch;media_content:languages
ab6ccdd7-e89a-4b0d-9ce3-016c6bfa0eb7;Sprache Serbisch;media_content:languages
865e8c3a-d5d6-4158-8c92-a5a1c661f333;Sprache Spanisch;media_content:languages
83ea1f17-dcdb-4fde-bb57-676bc39c504e;Sprache Tschechisch;media_content:languages
54ca860a-c849-4bc2-be8e-15c64d060a5b;Sprache Türkisch;media_content:languages
15e37762-099a-431c-8097-cdd2fe1f10a4;Sprache Ukrainisch;media_content:languages
e1c1657f-67f9-45a6-9ec6-5477a11141d2;Sprache Ungarisch;media_content:languages
0cc465ab-fe33-4cc2-9564-459e45c621d2;Sprache: Deutsch, Schweizerdeutsch, Französisch;media_content:languages
613f609c-c807-44d8-8dc7-9b8e22023eb5;Sprache: Französisch;media_content:languages
b63ace97-2fd3-445c-bbea-bc34d91412b1;Subtitles: English;media_content:languages
661e3291-3507-4fdf-928a-d17b79c5374e;Tibetisch;media_content:languages
aeee2162-0eb1-4b2c-a2dd-ed286ab1b99f;Tschechisch;media_content:languages
d3601f36-933a-4aa0-8083-ef46e4528bd5;Türkisch;media_content:languages
aca9ccb1-b8a5-4b93-9063-a9ebd5e7265b;Ukrainisch;media_content:languages
56d29496-2ce6-4022-96f7-b4ed9d6c90d4;Ungarisch;media_content:languages
ef077c61-9b27-4512-8b59-e1a62502b9f5;Untertitel Deutsch;media_content:languages
855dd205-f734-45c0-9de1-3a38f62aadce;Untertitel Deutsch/Englisch;media_content:languages
be0d9fd7-af5a-4b4e-ba8b-579a3f230709;Untertitel Deutsch/Italienisch;media_content:languages
ebfb2f71-48ff-4700-a57d-b8464eaa6934;Untertitel Englisch;media_content:languages
890702d3-c1c8-4286-b70c-0ea2521bf408;Untertitel Französisch;media_content:languages
c6fcb9f8-a425-4c9b-b484-180a8ad25b51;Untertitel Französisch/Englisch;media_content:languages
e26aae76-1560-4ad3-b36b-a20247a8f282;Untertitel Italienisch;media_content:languages
2bbd9461-e4f5-44ba-946b-8283bfe98dce;Untertitel: Deutsch;media_content:languages
eb5ed047-9429-45db-8f56-a9cee3e8af16;Untertitel: Englisch;media_content:languages
5e2d7dc3-c79b-4cc9-a56c-95a514076c86;Zitate teilweise in Englisch;media_content:languages
a14072ff-f6e2-43a7-b109-98d3fc38c704;16 mm Film;media_content:recording_medium
7d650193-a45e-4295-a8ff-12f1548fc0be;16fps;media_content:recording_medium
5ec99284-65c1-4d56-b28c-026dc54ba6bd;18 bps;media_content:recording_medium
e2f04287-4684-4ef9-be70-d93206ff50cf;24 bps;media_content:recording_medium
0acc2a27-471a-4e8b-8f39-540fb07ee39b;25 fps;media_content:recording_medium
3921cb94-de8b-42b6-a68a-1f20125e2e1b;"Archivbestand: DV (SP; 48kHz)";media_content:recording_medium
7012cabc-9c7f-440a-969f-28b6ce6fac2a;Archivbestand: DVCam;media_content:recording_medium
9da64843-e047-4562-beb4-cde24bf5d87e;Archivbestand: DVD;media_content:recording_medium
553d8246-0adc-44de-a063-073fd5ae63c6;Archivbestand: MiniDV;media_content:recording_medium
9e577452-e76e-42a7-87f2-d2186d2564a8;Archivbestand: U-Matic;media_content:recording_medium
e4d8cf6a-d785-497c-a58b-60138730c865;Archivbestand: VHS;media_content:recording_medium
2214316d-d97b-41a2-8050-fd61945fc79f;Audiokassette;media_content:recording_medium
48b5283a-428c-4f37-9ad1-91be2d2f716c;Digi Beta;media_content:recording_medium
998f364c-5bc0-40ca-8d03-b3a8bf60df6f;DigiBeta;media_content:recording_medium
b973d5cf-78ec-4e48-abf6-a45ed774afef;Drehfomrat Sony A7S Mark II;media_content:recording_medium
1bad659d-78cb-4f45-a944-36008b79e2ee;Drehformat  Blackmagic Pocket;media_content:recording_medium
faca40d9-a90f-4e25-8f29-734e5ac69a50;Drehformat 16mm;media_content:recording_medium
c3989851-f287-42bb-a3f1-6a1987e00726;Drehformat 35mm;media_content:recording_medium
639f7849-7f60-40f6-a8c6-b328c66ad4bb;Drehformat Alpha 7s;media_content:recording_medium
f9a8c425-a2c0-44ef-9b2d-db113d99599e;Drehformat Arri Alexa;media_content:recording_medium
5a6907a3-ffb1-430f-980f-8fc3f0930fc4;Drehformat ARRI Alexa ProRes;media_content:recording_medium
c342ff1d-ed03-4e80-9444-478491543197;Drehformat ARRI Alexa Raw;media_content:recording_medium
cd20998b-6b61-4562-8506-2dc312ff3c6f;Drehformat AVCHD;media_content:recording_medium
b7cb58be-7d5d-4775-9630-20298ca8cc93;Drehformat Beta SP;media_content:recording_medium
d83fa485-ff90-4cf1-b5a5-d27746a4c415;Drehformat Blackmagic Ursa Mini Pro;media_content:recording_medium
2611bdde-db8f-45d4-a76e-efda4f96c465;Drehformat Canon 5D Mark III;media_content:recording_medium
8c9aa187-0092-4e0d-8c15-217b992e1b7b;Drehformat Canon 5D Mk III / Magic Lantern Raw 2.0;media_content:recording_medium
2cbd5184-9eff-49a9-94ff-823deb9e9718;Drehformat Canon 7D;media_content:recording_medium
afd0704a-85b8-425b-a7c3-17a193dcbc54;Drehformat Canon EOS;media_content:recording_medium
1be5d9a3-519b-42e1-b58f-0737e704efbd;Drehformat Canon EOS 5D Mark III;media_content:recording_medium
ff10d9f7-9eba-4e4a-94c7-0d8bdf7b7464;Drehformat Canon Eos C100 Mark II;media_content:recording_medium
56ad67eb-7cec-41fd-9168-3ab31830b829;Drehformat Go Pro;media_content:recording_medium
6f7cec8e-386a-4420-96fb-4edb31952567;Drehformat h264;media_content:recording_medium
b5b8b37d-4949-4888-8020-e66fb5b43ae1;Drehformat HD;media_content:recording_medium
65869d29-6c5a-475f-b079-4bd54496a007;Drehformat HDCam;media_content:recording_medium
ab049abe-dcb6-4d7b-9f83-da3b8b41f7f8;Drehformat HDV;media_content:recording_medium
775a22e7-db19-473e-8e49-f9aa86ab0950;Drehformat iPhone;media_content:recording_medium
15afbf09-c886-4e54-b6fd-ccf9ac69703a;Drehformat Lumix GH4;media_content:recording_medium
acf79912-2198-4701-8fd5-bcab4c076a25;Drehformat MiniDV;media_content:recording_medium
ced1f892-c776-453b-9a3e-1cf8a95230bf;Drehformat nanoflash;media_content:recording_medium
5d8c887c-a9e9-41f5-ae68-7ca22a43f2cc;Drehformat Nikon D810;media_content:recording_medium
8319a0ad-4c3d-44c7-a4fa-dd8b21722fd4;Drehformat NikonD5200;media_content:recording_medium
4bfd03ac-44d4-421f-81c5-ce1b52834167;Drehformat Panasonic GH5;media_content:recording_medium
394a8c51-2a7d-4084-9b8a-e3e395bbfa34;Drehformat ProRes;media_content:recording_medium
74b6a38d-f67d-4750-a7aa-3fdab98ed45c;Drehformat RED;media_content:recording_medium
3f983e66-2b73-4267-83ba-f2364c25e82c;Drehformat RED Epic;media_content:recording_medium
23684df5-26a1-4ff8-8513-d4f8cf7f3e88;Drehformat Sony;media_content:recording_medium
7698ed5e-65fb-4df1-8f68-56931511451d;Drehformat Sony Alpha R;media_content:recording_medium
af44609f-8d77-44e9-bad1-da1f2d863abd;Drehformat Sony FS-5;media_content:recording_medium
cfc4e65d-4c95-47c4-9cc5-056ed815cfa6;Drehformat Sony FS-7;media_content:recording_medium
98c80c9a-fbec-4840-bc41-4a3ad15256bd;Drehformat Sony Z1;media_content:recording_medium
75b4f5cd-13b2-499e-8e69-f151a1e91ba7;Drehformat Super 16mm;media_content:recording_medium
eeb170ef-82d5-4c31-83ac-d96358d87f35;Drehformat XAVC;media_content:recording_medium
db7905bf-e88e-4f7c-9559-6e6b91e45c2d;Drehformat XD Cam HD;media_content:recording_medium
ba7d327e-5a8c-49bf-8ef2-91b96fdfe429;Drehformat XDCamEX;media_content:recording_medium
6261d691-f5b5-4837-bc01-d7cd644a472e;Drehformat: A7S, FS5, VariCam, C100;media_content:recording_medium
33ddc820-6786-40f0-9b1e-199d6afd1433;Drehformat: Analog;media_content:recording_medium
b035cc43-7c8e-4081-a1a9-41e9833b1e19;Drehformat: Digibeta;media_content:recording_medium
cfb3ca45-6258-4bf3-9bb8-f22c7978bff6;Drehformat: Digital;media_content:recording_medium
8ccd1b72-159c-441d-977b-dd95e18daf9f;Drehformat: DVCAM;media_content:recording_medium
052226e5-e2cf-41ca-9005-3711f70ea160;Drehformat: DVCPRO50;media_content:recording_medium
11f1e878-7253-4737-89ac-3309b58e15ad;Drehformat: ProRes;media_content:recording_medium
c808f597-214f-4899-af50-cc190818e72f;Drehformat: RED DRAGON;media_content:recording_medium
8facf6f1-c569-4a4e-926f-052e5de1e1fc;Drehformat: Sony F55, Sony A7S Mk II;media_content:recording_medium
85ff9a76-e6c1-43c5-9ee0-ee3909015651;DVD;media_content:recording_medium
dc2bdae2-1cc1-49ba-b329-9caeb62dbaf2;DVD Image;media_content:recording_medium
facd3a4b-b25d-4eba-ad79-ac2b6f33eabd;Handykamera;media_content:recording_medium
b7fbf756-78fe-4197-bc99-00dc5e347e74;HD cam;media_content:recording_medium
1d4719cc-63ce-4a27-86d3-49631da44608;Mini DV;media_content:recording_medium
cbeb32c3-2e87-461c-a564-3682c9bbc4bb;"Original: Kleinbilddia Farbe; Digitalisat: TIFF";media_content:recording_medium
c44ecc98-d9f6-46cf-8df1-5f7a84edd677;Super-8 Film;media_content:recording_medium
ff0b0811-9c4a-4deb-87af-b3d8888db200;XDCam EX;media_content:recording_medium
7d979f43-214c-4297-b1cc-a7d47839415e;2k DCP;media_content:video_formats
87254f04-1f9c-4327-8154-3148b067d390;422 (HQ);media_content:video_formats
eba0633f-37d3-4562-87ca-7de62e8720bf;H.264;media_content:video_formats
0516c3d0-c0b4-411b-9b4e-a541bd7e6ffc;HFR;media_content:video_formats
065900c3-b3b4-41a9-afbc-e15afee2793d;High speed;media_content:video_formats
fca16ce4-6cd4-4c9f-8b9b-ba473b76ee96;JPEG;media_content:video_formats
c98f3d58-9311-4b6b-a8fb-2fe677f08a2f;MP4;media_content:video_formats
35b5373f-2170-49e1-9735-fc838308f6c0;Original: JPEG;media_content:video_formats
3bde23ba-afc6-413b-b9e8-b0fe18a24bb2;PNG;media_content:video_formats
d41bb2fd-afb0-4e57-9f74-2364f3b1a4e9;ProRes;media_content:video_formats
e310e72e-de4c-4781-b870-e5f581b44c85;ProRes 422;media_content:video_formats
78b6ff38-92f4-490a-a1da-9bacd5d280a4;Quicktime;media_content:video_formats
ae0b3a82-61b0-4766-8318-4fa1a4df837f;RAW;media_content:video_formats
8edf5765-d849-4637-b92c-a4d68107586c;schwarz-weiss;media_content:video_formats
d0428790-fcbc-4932-9ec8-b86da3a341d9;Single Channel | Full HD | Color | Sound | 13 min 32 s;media_content:video_formats
05a48a22-47c2-44b4-b5e1-1998d441e7d1;Vorführfomat 35mm(blow up);media_content:video_formats
57e1bf61-1d8c-4c5c-b602-871903431e7b;Vorführformat BetaSP;media_content:video_formats
6423a910-2055-482e-baba-4886c648d114;Vorführformat Blu-ray;media_content:video_formats
bb18d297-5b4e-4255-bca4-9a2b5847281d;Vorführformat DCP;media_content:video_formats
4a4672f2-e4d2-4fb6-b133-c22c5f875daf;Vorführformat DigiBeta;media_content:video_formats
a669e4a4-1815-4631-a48b-a141bcd96a1d;Vorführformat DVD;media_content:video_formats
fee8cc8b-1482-410f-8101-20828d730d1d;Vorführformat HDCam;media_content:video_formats
8eed9a47-8911-44be-b8c0-2b3c0f372d4d;Vorführformat HDCamSR;media_content:video_formats
585e0d77-3654-40fd-a006-bc33935296bc;Vorführformat QuickTimeMovie;media_content:video_formats
8cf7922a-6091-48a2-965c-4bd5b2e51ffe;Vorführformat U-matic;media_content:video_formats
d4cfc253-4648-4da3-93c9-ebec3771bcf1;Vorführformat VHS;media_content:video_formats
3595b2c4-6c61-4915-b5e8-cdd79a2bb739;2-Kanal-Video- und Audio-Installation;media_content:work_type
550bd5af-3177-433e-ab0a-c2cb3eec8f53;30 Klingeltöne 1-10' generative Klanginstallation - Standalone geschrieben in MAX/MSP;media_content:work_type
29275c5a-f2ec-40e5-8db2-254fb871f01f;3D-Rendering;media_content:work_type
764e8645-b92c-409b-b7ba-695f9d27c75f;Action Still;media_content:work_type
fc0a9966-6364-4fc3-9ecd-87d52b7991d9;Analoge Fotografie;media_content:work_type
8ce4c18a-f016-4171-8fe2-b60a947bf694;analoges Spiel;media_content:work_type
505175f0-2ad0-4b43-9eb3-9ba86c8142fe;Animation;media_content:work_type
ba8f60a6-d92a-4c7d-99bb-ebd24b9f4295;Audio;media_content:work_type
56842c66-2024-46d3-878c-7a3a45c13e77;Audioslideshow;media_content:work_type
baad9f44-3a32-4bee-a906-510113b44cbb;Ausstellung;media_content:work_type
a414b52a-c366-4da8-829b-4e02fbf33a38;"Bildschirm""foto""";media_content:work_type
6479e0f4-d3ea-4cc6-808b-c2dccd9953fd;Brettspiel;media_content:work_type
f1d8d80a-b695-479c-8fdd-f6b629d617a0;Broschüre;media_content:work_type
91a76725-c7da-4c4a-9d5a-26884d18be35;Buch;media_content:work_type
7bd15497-bdd8-49d6-b51e-39e29a2f2473;Collage;media_content:work_type
f1587869-bb5f-4748-8c3f-7754bca1ab62;Computergenieriertes Bild;media_content:work_type
73f233bb-a618-4467-bd58-661103503dde;Computergrafik;media_content:work_type
31a1e83b-2ce6-4a77-8fa9-22d3ac2baaf8;Digital Painting;media_content:work_type
f9f48f85-d99b-4a51-9bec-109cf34be827;Digitale Fotografie;media_content:work_type
cb3bdadc-53a5-43a3-b213-65d4bf526702;Digitale Kollage;media_content:work_type
9584b503-03d4-42ad-b489-3a2bbebdc73d;Digitale Rekonstruktion;media_content:work_type
a1c971ed-9707-4386-bf65-52c5eb8ddef2;Digitale Simulation;media_content:work_type
c3d1ad8a-34f9-4277-9adf-a6ec03922c5a;digitales Modell;media_content:work_type
cca3048e-9ade-4948-b3ba-0176c3f8af49;Druck;media_content:work_type
a043f687-9575-418a-acaa-e0f64c457ffd;E-Learning Plattform;media_content:work_type
15b0cc52-9c3c-4a27-aa87-5863b5ba128a;Enkaustik;media_content:work_type
63c2366d-3d2b-4e4a-a5af-e406094ae47b;Faltmodell aus Papier;media_content:work_type
a45ad9ac-11cf-49a8-8e0a-45e12a85f07d;File;media_content:work_type
bf910e20-5fdf-45fb-8974-a7ade1e67792;Film;media_content:work_type
beb1175d-876d-4f32-83b7-c9867e9a7b42;Film Still;media_content:work_type
30f751b7-dabd-4f55-a499-6a1f2593f1aa;Film | 43 min;media_content:work_type
dac57e01-3d71-422c-a46f-c27f77b35180;Filmstill;media_content:work_type
14129ff1-6d3e-4d45-be08-5bd767eed1c6;Filmtipp;media_content:work_type
e09003e0-3de2-4d8b-9bcb-583076fe8fcb;Fotobuch;media_content:work_type
1dfd4d3c-7dde-45a7-b153-4d782cb4150d;Fotografie;media_content:work_type
1947835c-d986-46eb-bea5-16610a64f2f8;Fotografische Mikroskop-Aufnahme;media_content:work_type
1ea8da15-211c-4bf9-a1c3-4151da7d01ce;Fotomontage;media_content:work_type
6a563e0c-293b-4577-a44b-668d1f9697e0;Game (Computerspiel);media_content:work_type
f671eb22-cad4-4c0b-9c93-b4c2dccb90a2;Game-Screenshot;media_content:work_type
a54a75d0-2ff3-4c08-97a7-33618342214f;gefilmtes Musiktheater;media_content:work_type
ea3678b1-3cf2-4eeb-9024-f358bf31c476;Gemälde;media_content:work_type
1b48c925-01bf-4d5f-a373-c034035f8e80;Graffiti;media_content:work_type
240ea04a-e288-4c0b-b5c2-bff913dfc477;Grafik;media_content:work_type
6dcbdf3f-d51e-42f3-835c-b6165ee9c94a;Graphic Recording;media_content:work_type
db25c60f-90dd-4cae-9984-fbb3ddcf6ca4;Handzeichnung;media_content:work_type
93d1c0a4-a80e-40f4-a6da-b063628e5026;Instagram;media_content:work_type
960ea062-1a13-48e9-ab72-48b94a67e1fb;Installation;media_content:work_type
12e5e5f9-b847-49c7-9e80-db0f34563a1a;Installation mit fluoreszierendem Licht;media_content:work_type
474c3306-a98e-44cd-a12a-4d6db21b60c3;interface design;media_content:work_type
1dd07930-ac4c-4568-a788-fe3b27a0fed1;Interview;media_content:work_type
895977e7-a9fb-417b-b8a6-d5607604de43;Kombination von 3D-Konstruktion, Fotografie und digitale Bildbearbeitung;media_content:work_type
00b1de6d-3e1a-4554-aacc-727f043cd302;Konzertvideo;media_content:work_type
7a57e5bb-b3d4-40f2-8432-de22951bf09d;Lichtinstallation;media_content:work_type
6ef00586-d3f1-4879-a7b7-2b8ffd1bbe8c;Manuskript;media_content:work_type
ca16078a-85f8-46e6-b373-c35e39014ac6;Multimedia-Applikation;media_content:work_type
520f8480-52b2-4937-ae1f-de983683de81;Online Game;media_content:work_type
e7cdc8c8-0314-4259-9eb3-367fe0ec4c22;pdf;media_content:work_type
56290ac8-ca6b-47d7-89d5-2013cae1dddb;PDF;media_content:work_type
81b8d53e-49a6-495f-80b1-78a1eb66b302;Performancekunst;media_content:work_type
7c183a52-53a3-464d-9a8a-9649498b1804;Pixelbild;media_content:work_type
f137f5d1-8935-483f-9a98-75275ef6b65d;Plakat;media_content:work_type
297422e1-1c99-4aa0-a07e-05a5618746e0;Plattform;media_content:work_type
dd16e7c3-0fb8-4d2a-94bc-851281e5b6c7;Port;media_content:work_type
6dde3287-0582-433e-a145-8582fbe9ec50;Portrait;media_content:work_type
ac9e1c2a-3a5e-4eeb-8dd8-492c883815de;Poster;media_content:work_type
ddfd90b5-7b08-4a74-8af6-74f07242ba5b;Powerpoint;media_content:work_type
e172f13f-ce8e-4089-b212-60906a750cfc;Processing;media_content:work_type
7ca8a7d7-c71f-4936-a60e-5ecac3ed6de1;Präsentation;media_content:work_type
b97cd370-d528-459d-ade3-2bf8d1ea1842;Rauminstallation;media_content:work_type
0966628e-ae18-4823-9dac-5407154bdd9b;Realistische Computergrafik;media_content:work_type
f0c5214b-ff9a-4e35-ac3e-f8bbeb60d982;Rendering;media_content:work_type
34f86898-f847-49ff-8cd5-1453c37fbf36;Screencast;media_content:work_type
bf11e929-4adb-419d-9ca5-62a3f7a0732c;Screenshot;media_content:work_type
422b0c67-2ffe-4ec5-8bca-842b5350ec67;Simulation;media_content:work_type
55ca7b3d-7ef6-4e54-9b73-2561236036ec;Source Code;media_content:work_type
163f3f95-5129-460e-abef-956ffdc883e4;Stop Motion;media_content:work_type
56f4ff7e-268c-41e3-ab67-4a12dd73a427;Storyapp;media_content:work_type
94d90df0-e57a-488d-ba82-aaac07157095;SVG-Grafik;media_content:work_type
bf9802b0-ca2f-49d2-bef5-2dbb69613ad0;Teaser;media_content:work_type
dcaa8e6f-d3ec-444b-b157-9d9faf6f43ca;Theoriearbeit;media_content:work_type
72399c61-4df4-490f-b429-2dd0f6687c93;Tool;media_content:work_type
dd38fb06-c2cc-4e92-bffa-67d9e309ca8a;Trailer;media_content:work_type
7838a955-f477-40f1-8c57-8ab24359771b;Vektorgrafik;media_content:work_type
9b89c6bc-49dd-47ab-a3ba-bed4c42e153b;Video;media_content:work_type
4230a292-9b97-479a-90e2-c1521ad7d1f4;Videoaufzeichnung;media_content:work_type
042a92b8-29a1-4dc8-b21a-360577e16bb3;Videoinstallation;media_content:work_type
b60b623d-9c84-4df1-a773-3a3fd4538d86;Videostill;media_content:work_type
cab94c84-349b-4bcb-8467-9e14b819cf95;Web Applikation;media_content:work_type
526063cf-41e0-4e34-9e56-c28404d7b95f;Webinar;media_content:work_type
2c607c1b-c534-48f7-8f2f-518f0c4bacb5;Webvideo;media_content:work_type
81d65ba0-4aea-459b-90ce-a11568c93eae;XML-Dokument;media_content:work_type
4734a40f-074e-4f26-8cb1-f60a6dbe0961;YouTube;media_content:work_type
4bae12b7-5f54-4efa-b308-cef7292ae68f;Zeichnung;media_content:work_type
472a6f03-45e1-4413-851e-f60e762f84c1;Zeitungsbeilage;media_content:work_type
07f11308-6edd-4bab-989c-028c9b6e35bc;ZIP-Datei;media_content:work_type
7ff80e5f-2ff3-435d-93c8-b81a6c81788d;Zoom Talk;media_content:work_type
CSV

def conn
  ActiveRecord::Base.connection
end

def quoted(values)
  values.map { |v| conn.quote(v) }.join(', ')
end

def report(title)
  puts "\n== #{title}"
  ([SOURCE] + NEW_META_KEYS.keys).each do |id|
    next unless MetaKey.exists?(id)

    puts format('%-45s keywords: %4d  meta_data: %6d  assignments: %6d',
                id,
                Keyword.where(meta_key_id: id).count,
                MetaDatum.where(meta_key_id: id).count,
                MetaDatum::Keyword.joins(:keyword).where(keywords: { meta_key_id: id }).count)
  end
end

def check_mapping!
  unknown_targets = MAPPING.map { |r| r['meta_key_id'] }.uniq - NEW_META_KEYS.keys
  raise "unknown target meta keys: #{unknown_targets.join(', ')}" if unknown_targets.any?

  keywords = Keyword.where(id: MAPPING.map { |r| r['keyword_id'] }).index_by(&:id)
  MAPPING.each do |r|
    kw = keywords[r['keyword_id']]
    raise "keyword missing: #{r['keyword_id']} #{r['term']}" unless kw
    raise "keyword not in #{SOURCE}: #{kw.id} #{kw.term} (#{kw.meta_key_id})" unless kw.meta_key_id == SOURCE
    next if kw.term.gsub(/[[:space:]]+/, ' ') == r['term'].gsub(/[[:space:]]+/, ' ')

    puts "WARN term differs: #{kw.id} #{r['term'].inspect} vs #{kw.term.inspect}"
  end
end

def create_meta_keys!
  position = MetaKey.where(vocabulary_id: 'media_content').maximum(:position).to_i
  NEW_META_KEYS.each do |id, labels|
    if (mk = MetaKey.find_by(id: id))
      raise "#{id} exists but is not of type Keywords" unless mk.meta_datum_object_type == 'MetaDatum::Keywords'
      raise "#{id} exists and has keywords" if Keyword.where(meta_key_id: id).exists?

      puts "meta key exists: #{id}"
      next
    end

    position += 1
    MetaKey.create!(id: id,
                    vocabulary_id: 'media_content',
                    meta_datum_object_type: 'MetaDatum::Keywords',
                    is_extensible_list: false,
                    keywords_alphabetical_order: true,
                    multiple_selection: true,
                    selection_field_type: 'auto',
                    is_enabled_for_media_entries: true,
                    is_enabled_for_collections: true,
                    labels: labels,
                    position: position)
    puts "created meta key: #{id}"
  end
end

def add_to_contexts!
  ContextKey.where(meta_key_id: SOURCE).order(:context_id).each do |source_ck|
    new_ids = NEW_META_KEYS.keys - ContextKey.where(context_id: source_ck.context_id).pluck(:meta_key_id)
    next if new_ids.empty?

    ContextKey.where(context_id: source_ck.context_id)
      .where('position > ?', source_ck.position)
      .update_all(['position = position + ?', new_ids.size])
    # insert_all: Orderable would append on create
    ContextKey.insert_all!(new_ids.each.with_index(1).map do |id, i|
      { context_id: source_ck.context_id, meta_key_id: id, position: source_ck.position + i }
    end)
    puts "context #{source_ck.context_id}: added #{new_ids.size} meta keys after position #{source_ck.position}"
  end
end

def move_keywords!(target, keyword_ids)
  ids = quoted(keyword_ids)

  # one target meta datum per resource; created_by falls back to the resource creator
  created = conn.exec_update(<<~SQL)
    INSERT INTO meta_data (meta_key_id, type, media_entry_id, collection_id, created_by_id)
    SELECT DISTINCT #{conn.quote(target)}, 'MetaDatum::Keywords', src.media_entry_id, src.collection_id,
           COALESCE(src.created_by_id, me.creator_id, c.creator_id)
    FROM meta_data src
    JOIN meta_data_keywords mdk ON mdk.meta_datum_id = src.id
    LEFT JOIN media_entries me ON me.id = src.media_entry_id
    LEFT JOIN collections c ON c.id = src.collection_id
    WHERE src.meta_key_id = #{conn.quote(SOURCE)}
      AND mdk.keyword_id IN (#{ids})
      AND NOT EXISTS (
        SELECT 1 FROM meta_data tgt
        WHERE tgt.meta_key_id = #{conn.quote(target)}
          AND (tgt.media_entry_id = src.media_entry_id OR tgt.collection_id = src.collection_id))
  SQL

  moved = conn.exec_update(<<~SQL)
    UPDATE meta_data_keywords mdk
    SET meta_datum_id = tgt.id
    FROM meta_data src, meta_data tgt
    WHERE mdk.meta_datum_id = src.id
      AND src.meta_key_id = #{conn.quote(SOURCE)}
      AND mdk.keyword_id IN (#{ids})
      AND tgt.meta_key_id = #{conn.quote(target)}
      AND (tgt.media_entry_id = src.media_entry_id OR tgt.collection_id = src.collection_id)
  SQL

  # after the assignments: keyword updates touch meta_data_keywords, whose deferred
  # consistency check sees the meta_datum_id at that point
  n = Keyword.where(id: keyword_ids).update_all(meta_key_id: target)

  puts format('%-35s keywords: %3d  new meta_data: %5d  moved assignments: %5d', target, n, created, moved)
end

ActiveRecord::Base.transaction do
  report 'before'

  check_mapping!
  unmapped = Keyword.where(meta_key_id: SOURCE).where.not(id: MAPPING.map { |r| r['keyword_id'] }).count
  puts "\nkeywords staying in #{SOURCE}: #{unmapped}"
  assignments_before = MetaDatum::Keyword.joins(:meta_datum).where(meta_data: { meta_key_id: [SOURCE] + NEW_META_KEYS.keys }).count

  puts
  create_meta_keys!
  puts
  add_to_contexts!
  MetaKey.find(SOURCE).update!(labels: SOURCE_LABELS)
  puts "relabeled #{SOURCE}: #{SOURCE_LABELS}"

  touched = MetaDatum::Keyword.joins(:meta_datum)
    .where(meta_data: { meta_key_id: SOURCE }, keyword_id: MAPPING.map { |r| r['keyword_id'] })
    .distinct.pluck(:meta_datum_id)

  puts
  MAPPING.group_by { |r| r['meta_key_id'] }.each do |target, rows|
    move_keywords!(target, rows.map { |r| r['keyword_id'] })
  end

  n = MetaDatum.where(id: touched)
    .where('NOT EXISTS (SELECT 1 FROM meta_data_keywords mdk WHERE mdk.meta_datum_id = meta_data.id)')
    .delete_all
  puts "\ndeleted empty #{SOURCE} meta_data: #{n}"

  assignments_after = MetaDatum::Keyword.joins(:meta_datum).where(meta_data: { meta_key_id: [SOURCE] + NEW_META_KEYS.keys }).count
  raise "assignments changed: #{assignments_before} -> #{assignments_after}" unless assignments_before == assignments_after

  # run deferred constraint triggers now instead of at commit
  conn.execute('SET CONSTRAINTS ALL IMMEDIATE')

  report 'after'

  puts "\n== context_keys"
  ContextKey.where(context_id: ContextKey.where(meta_key_id: SOURCE).select(:context_id))
    .order(:context_id, :position)
    .each { |ck| puts format('%-20s %3d  %s', ck.context_id, ck.position, ck.meta_key_id) }

  if ENV['DRY_RUN'] == 'true'
    puts "\nDRY RUN - rolled back"
    raise ActiveRecord::Rollback
  else
    puts "\nCOMMITTED"
  end
end

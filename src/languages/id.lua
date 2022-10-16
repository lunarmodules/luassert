local s = require('say')

s:set_namespace('id')

s:set("assertion.same.positive", "Objek yang diharapkan akan sama.\nLulus:\n%s\nDiharapkan:\n%s")
s:set("assertion.same.negative", "Objek yang diharapkan tidak sama.\nLulus:\n%s\nTidak diharapkan:\n%s")

s:set("assertion.equals.positive", "Objek yang diharapkan setara.\nLulus:\n%s\nDiharapkan:\n%s")
s:set("assertion.equals.negative", "Objek yang diharapkan tidak setara.\nLulus:\n%s\nTidak diharapkan:\n%s")

s:set("assertion.near.positive", "Nilai yang diharapkan mendekati.\nLulus:\n%s\nDiharapkan:\n%s +/- %s")
s:set("assertion.near.negative", "Nilai yang diharapkan tidak mendekati.\nLulus:\n%s\nTidak diharapkan:\n%s +/- %s")

s:set("assertion.matches.positive", "String yang diharapkan cocok.\nLulus:\n%s\nDiharapkan:\n%s")
s:set("assertion.matches.negative", "String yang diharapkan tidak cocok.\nLulus:\n%s\nTidak diharapkan:\n%s")

s:set("assertion.unique.positive", "Objek yang diharapkan unik:\n%s")
s:set("assertion.unique.negative", "Objek yang diharapkan tidak unik:\n%s")

s:set("assertion.error.positive", "Mengharapkan kesalahan yang berbeda.\nTertangkap:\n%s\nDiharapkan:\n%s")
s:set("assertion.error.negative", "Mengharapkan tidak ada kesalahan, tetapi menangkap:\n%s")

s:set("assertion.truthy.positive", "Diharapkan benar, tetapi nilainya adalah:\n%s")
s:set("assertion.truthy.negative", "Diharapkan tidak benar, tetapi nilainya adalah:\n%s")

s:set("assertion.falsy.positive", "Diharapkan salah, tetapi nilainya adalah:\n%s")
s:set("assertion.falsy.negative", "Diharapkan tidak salah, tetapi nilainya adalah:\n%s")

s:set("assertion.called.positive", "Diharapkan dipanggil %s kali, tetapi dipanggil %s kali")
s:set("assertion.called.negative", "Diharapkan tidak dipanggil tepat %s kali, tapi seperti itu.")

s:set("assertion.called_at_least.positive", "Diharapkan dipanggil setidaknya %s kali, tetapi dipanggil %s kali")
s:set("assertion.called_at_most.positive", "Diharapkan dipanggil paling banyak %s kali, tetapi dipanggil %s kali")
s:set("assertion.called_more_than.positive", "Diharapkan dipanggil lebih dari %s kali, tetapi dipanggil %s kali")
s:set("assertion.called_less_than.positive", "Diharapkan dipanggil kurang dari %s kali, tetapi dipanggil %s kali")

s:set("assertion.called_with.positive", "Fungsi tidak pernah dipanggil dengan argumen yang cocok.\nDipanggil dengan (panggilan terakhir jika ada):\n%s\nDiharapkan:\n%s")
s:set("assertion.called_with.negative", "Fungsi dipanggil dengan argumen yang cocok setidaknya sekali.\nDipanggil dengan (panggilan terakhir yang cocok):\n%s\nTidak diharapkan:\n%s")

s:set("assertion.returned_with.positive", "Fungsi tidak pernah mengembalikan argumen yang cocok.\nMengembalikan (panggilan terakhir jika ada):\n%s\nDiharapkan:\n%s")
s:set("assertion.returned_with.negative", "Fungsi mengembalikan argumen yang cocok setidaknya sekali.\nMengembalikan (panggilan terakhir yang cocok):\n%s\nTidak diharapkan:\n%s")

s:set("assertion.returned_arguments.positive", "Diharapkan dipanggil dengan argumen %s, tetapi dipanggil dengan %s")
s:set("assertion.returned_arguments.negative", "Diharapkan tidak dipanggil dengan argumen %s, tetapi dipanggil dengan %s")

-- errors
s:set("assertion.internal.argtolittle", "fungsi '%s' membutuhkan sedikitnya %s argumen, didapat: %s")
s:set("assertion.internal.badargtype", "Kesalahan pada argumen ke #%s untuk '%s' (%s diharapkan, mendapatkan %s)")

class NrsEnum {
  static const String irata_n1 = 'IRATA N1';
  static const String irata_n2 = 'IRATA N2';
  static const String irata_n3 = 'IRATA N3';
  /* static const String nr1 =
      'NR-1 - DISPOSIÇÕES GERAIS E GERENCIAMENTO DE RISCOS OCUPACIONAIS';
  static const String nr2 = 'NR-2 - INSPEÇÃO PRÉVIA (REVOGADA)';
  static const String nr3 = 'NR-3 - EMBARGO OU INTERDIÇÃO';
  static const String nr4 =
      'NR-4 - SERVIÇOS ESPECIALIZADOS EM ENGENHARIA DE SEGURANÇA E EM MEDICINA DO TRABALHO (SESMT)';
  static const String nr5 =
      'NR-5 - COMISSÃO INTERNA DE PREVENÇÃO DE ACIDENTES (CIPA)';
  static const String nr6 = 'NR-6 - EQUIPAMENTO DE PROTEÇÃO INDIVIDUAL (EPI)';
  static const String nr7 =
      'NR-7 - PROGRAMA DE CONTROLE MÉDICO DE SAÚDE OCUPACIONAL (PCMSO)';
  static const String nr8 = 'NR-8 - EDIFICAÇÕES';
  static const String nr9 =
      'NR-9 - PROGRAMA DE PREVENÇÃO DE RISCOS AMBIENTAIS (PPRA)';*/
  static const String nr10 =
      'NR-10 - SEGURANÇA EM INSTALAÇÕES E SERVIÇOS EM ELETRICIDADE';
  static const String nr11 =
      'NR-11 - TRANSPORTE, MOVIMENTAÇÃO, ARMAZENAGEM E MANUSEIO DE MATERIAIS';
  /* static const String nr12 =
      'NR-12 - SEGURANÇA NO TRABALHO EM MÁQUINAS E EQUIPAMENTOS';
  static const String nr13 = 'NR-13 - CALDEIRAS E VASOS DE PRESSÃO';
  static const String nr14 = 'NR-14 - FORNOS';
  static const String nr15 = 'NR-15 - ATIVIDADES E OPERAÇÕES INSALUBRES';
  static const String nr16 = 'NR-16 - ATIVIDADES E OPERAÇÕES PERIGOSAS';
  static const String nr17 = 'NR-17 - ERGONOMIA';
  static const String nr18 =
      'NR-18 - CONDIÇÕES E MEIO AMBIENTE DE TRABALHO NA INDÚSTRIA DA CONSTRUÇÃO';
  static const String nr19 = 'NR-19 - EXPLOSIVOS';
  static const String nr20 =
      'NR-20 - SEGURANÇA E SAÚDE NO TRABALHO COM INFLAMÁVEIS E COMBUSTÍVEIS';
  static const String nr21 = 'NR-21 - TRABALHOS A CÉU ABERTO';
  static const String nr22 =
      'NR-22 - SEGURANÇA E SAÚDE OCUPACIONAL NA MINERAÇÃO';
  static const String nr23 = 'NR-23 - PROTEÇÃO CONTRA INCÊNDIOS';
  static const String nr24 =
      'NR-24 - CONDIÇÕES SANITÁRIAS E DE CONFORTO NOS LOCAIS DE TRABALHO';
  static const String nr25 = 'NR-25 - RESÍDUOS INDUSTRIAIS';
  static const String nr26 = 'NR-26 - SINALIZAÇÃO DE SEGURANÇA';
  static const String nr27 =
      'NR-27 - REGISTRO PROFISSIONAL DO TÉCNICO DE SEGURANÇA DO TRABALHO NO MINISTÉRIO DO TRABALHO';
  static const String nr28 = 'NR-28 - FISCALIZAÇÃO E PENALIDADES';
  static const String nr29 =
      'NR-29 - NORMA REGULAMENTADORA DE SEGURANÇA E SAÚDE NO TRABALHO PORTUÁRIO';
  static const String nr30 = 'NR-30 - SEGURANÇA E SAÚDE NO TRABALHO AQUAVIÁRIO';
  static const String nr31 =
      'NR-31 - SEGURANÇA E SAÚDE NO TRABALHO NA AGRICULTURA, PECUÁRIA SILVICULTURA, EXPLORAÇÃO FLORESTAL E AQUICULTURA';
  static const String nr32 =
      'NR-32 - SEGURANÇA E SAÚDE NO TRABALHO EM SERVIÇOS DE SAÚDE';*/
  static const String nr33 =
      'NR-33 - SEGURANÇA E SAÚDE NO TRABALHO EM ESPAÇOS CONFINADOS';
  static const String nr35 = 'NR-35 - TRABALHO EM ALTURA';
  /*static const String nr36 =
      'NR-36 - SEGURANÇA E SAÚDE NO TRABALHO EM EMPRESAS DE ABATE E PROCESSAMENTO DE CARNES E DERIVADOS';*/
  static const String nr37 =
      'NR-37 - SEGURANÇA E SAÚDE EM PLATAFORMAS DE PETRÓLEO';
  static const String nr38 =
      'NR-38 - SEGURANÇA E SAÚDE NO TRABALHO NAS ATIVIDADES DE LIMPEZA URBANA E MANEJO DE RESÍDUOS SÓLIDOS';

  static const List<String> nrs = [
    irata_n1,
    irata_n2,
    irata_n3,
    /* nr1,
    nr2,
    nr3,
    nr4,
    nr5,
    nr6,
    nr7,
    nr8,
    nr9,*/
    nr10,
    nr11,
    /* nr12,
    nr13,
    nr14,
    nr15,
    nr16,
    nr17,
    nr18,
    nr19,
    nr20,
    nr21,
    nr22,
    nr23,
    nr24,
    nr25,
    nr26,
    nr27,
    nr28,
    nr29,
    nr30,
    nr31,
    nr32,*/
    nr33,
    nr35,
    // nr36,
    nr37,
    nr38,
  ];

  static String getNr(int index) {
    return nrs[index];
  }
}

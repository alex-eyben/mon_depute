require "nokogiri"
require "open-uri"

class CreateLawsJob < ApplicationJob
  queue_as :default
  
  def perform
    # Do something later
    laws = [['https://vie-publique.fr/loi/268070-loi-avia-lutte-contre-les-contenus-haineux-sur-internet',2039,'Adoptée',2019,7,9],
    ['https://www.vie-publique.fr/loi/20774-moralisation-de-la-vie-publique-loi-retablissant-la-confiance-dans-lac',119,'Adoptée',2017,8,9],
    ['https://www.vie-publique.fr/loi/20775-loi-securite-interieure-et-la-lutte-contre-le-terrorisme',138,'Adoptée',2017,10,3],
    ['https://www.vie-publique.fr/loi/20778-fin-de-la-recherche-et-de-lexploitation-des-hydrocarbures-conventionnel',139,'Adoptée',2017,10,10],
    ['https://www.vie-publique.fr/loi/20784-loi-de-finances-rectificative-pour-2017',345,'Adoptée',2017,12,12],
    ['https://www.vie-publique.fr/loi/20786-loi-orientation-et-reussite-des-etudiants-apb-parcoursup',351,'Adoptée',2017,12,19],
    ['https://www.vie-publique.fr/loi/20787-loi-relative-la-protection-des-donnees-personnelles-cnil-rgpd',389,'Adoptée',2018,2,13],
    ['https://www.vie-publique.fr/loi/20790-loi-egalim-equilibre-des-relations-commerciales-dans-le-secteur-agricol',729,'Adoptée',2018,5,30],
    ['https://www.vie-publique.fr/loi/20791-programmation-militaire-pour-les-annees-2019-2025-defense',433,'Adoptée',2018,3,27],
    ['https://www.vie-publique.fr/loi/20792-loi-pour-une-immigration-maitrisee-un-droit-dasile-effectif-et-une-int',578,'Adoptée',2018,4,22],
    ['https://www.vie-publique.fr/loi/20793-pour-un-nouveau-pacte-ferroviaire-loi-dhabilitation-ordonnances-de-re',942,'Adoptée',2018,6,13],
    ['https://www.vie-publique.fr/loi/20795-organisation-de-la-consultation-sur-laccession-la-pleine-souverainete',419,'Adoptée',2018,3,20],
    ['https://www.vie-publique.fr/loi/20796-lutte-contre-la-fraude-fiscale-sociale-et-douaniere-projet-de-loi',1171,'Adoptée',2018,9,26],
    ['https://www.vie-publique.fr/loi/20797-loi-elan-portant-evolution-du-logement-de-lamenagement-et-du-numerique',928,'Adoptée',2018,6,12],
    ['https://www.vie-publique.fr/loi/20799-loi-pour-la-liberte-de-choisir-son-avenir-professionnel-projet-de-loi',974,'Adoptée',2018,6,19],
    ['https://www.vie-publique.fr/loi/20803-projet-de-loi-de-finances-pour-2019-budget-2019',1429,'Adoptée',2018,11,20],
    ['https://www.vie-publique.fr/loi/20805-projet-de-loi-de-financement-de-la-securite-sociale-pour-2019-plfss',1330,'Adoptée',2018,10,30],
    ['https://www.vie-publique.fr/loi/20809-loi-du-24-decembre-2019-dorientation-des-mobilites-lom',2071,'Adoptée',2019,9,17],
    ['https://www.vie-publique.fr/loi/21003-loi-pour-un-etat-au-service-dune-societe-de-confiance-droit-lerreur',365,'Adoptée',2018,1,30],
    ['https://www.vie-publique.fr/loi/21026-loi-manipulation-de-linformation-loi-fake-news',1432,'Adoptée',2018,11,20],
    ['https://www.vie-publique.fr/loi/21033-loi-agence-nationale-de-la-cohesion-des-territoires',1912,'Adoptée',2019,5,21],
    ['https://www.vie-publique.fr/loi/21036-loi-10-avril-2019-ordre-public-manifestations',1662,'Adoptée',2019,2,5],
    ['https://www.vie-publique.fr/loi/24180-projet-de-loi-transformation-fonction-publique',1923,'Adoptée',2019,5,28],
    ['https://www.vie-publique.fr/loi/268659-projet-de-loi-bioethique-pma',2146,'Adoptée',2019,10,15],
    ['https://www.vie-publique.fr/loi/268695-projet-de-loi-relatif-competences-de-la-collectivite-europeenne-dalsace',1988,'Adoptée',2019,6,26],
    ['https://www.vie-publique.fr/loi/268696-projet-de-loi-organisation-et-la-transformation-du-systeme-de-sante',1814,'Adoptée',2019,3,26],
    ['https://www.vie-publique.fr/loi/269264-loi-ecole-de-la-confiance-du-26-juillet-2019-loi-blanquer',1709,'Adoptée',2019,2,19],
    ['https://www.vie-publique.fr/loi/269300-loi-pacte-croissance-et-transformation-des-entreprises',1209,'Adoptée',2018,10,9],
    ['https://www.vie-publique.fr/loi/269313-loi-programmation-2018-2022-et-reforme-pour-la-justice',1633,'Adoptée',2019,1,23],
    ['https://www.vie-publique.fr/loi/269375-loi-ratification-ceta-accord-ue-canada',2059,'Adoptée',2019,7,23],
    ['https://www.vie-publique.fr/loi/270746-loi-du-28-decembre-2019-de-finances-pour-2020-budget-2020',2307,'Adoptée',2019,11,19],
    ['https://www.vie-publique.fr/loi/270993-loi-du-24-decembre-2019-de-financement-de-la-securite-sociale-pour-2020',2337,'Adoptée',2019,12,3],
    ['https://www.vie-publique.fr/loi/271281-proposition-de-loi-action-contre-les-violences-au-sein-de-la-famille',2147,'Adoptée',2019,10,15]]
    laws.each do |law|
      createLaw(law)
    end
  end

  def nokogiriDocument(link)
    html_file = open(link)
    Nokogiri::HTML(html_file)
  end

  def getTitle(link)
    title = ""
    nokogiriDocument(link).search("h1 span").each do |element|
      title = element.text.strip
    end
    return title
  end

  def getContent(link)
    content = ""
    nokogiriDocument(link).search(".chapo span").each do |element|
      content = element.text.strip
    end
    return content
  end

  def getTags(link)
    tags = []
    nokogiriDocument(link).search(".tagsBox a").each do |element|
      tag = element.text.strip
      tags << tag
    end
    return tags
  end

  def createLaw(law)
    link = law[0]
    newLaw = Law.create!(
      {
        title: getTitle(link),
        content: getContent(link),
        ressource_link: link,
        current_status: law[2],
        last_status_update: Date.new(law[3], law[4], law[5]),
        scrutin_id: law[1]
      }
    )
    getTags(link).each do |tag|
      newLaw.tag_list.add(tag)
    end
    newLaw.save
  end

end
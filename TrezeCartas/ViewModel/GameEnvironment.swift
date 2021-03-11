//
//  CardData.swift
//  TrezeCartas
//
//  Created by Evaldo Garcia de Souza Júnior on 10/02/21.
//

import Foundation
import SwiftUI


class GameEnvironment: ObservableObject {
    
    @Published var cards = originalCards
    @Published var maxID = originalCards.count - 1
    
    @Published var attributes: Attributtes
    
    var blockEndingText: String = ""
    
    
    
    init(){
        attributes = Attributtes()
        reset()

//        guard let jsonPath = Bundle.main.path(forResource: "TeXeroCards", ofType: "txt") else { fatalError() }
//
//        do {
//            let jsonData = try String(contentsOfFile: jsonPath, encoding: String.Encoding.utf8).data(using: String.Encoding.utf8)!
//            let jsonArray = try JSONDecoder().decode([JSONCard].self, from: jsonData)
//
//
//            for row in jsonArray {
//                print(row)
//            }
//        } catch{
//            print("its a thursday")
//            print(error)
//        }
        
    }
    
    func reset() {
        attributes = Attributtes()
        
        shuffleCards()
        self.objectWillChange.send()
    }
    /**
    Reads a multiline, tab-separated String and returns an Array<NSictionary>, taking column names from the first line or an explicit parameter
    */
    func JSONObjectFromTSV(tsvInputString:String, columnNames optionalColumnNames:[String]? = nil) -> Array<NSDictionary>
    {
      let lines = tsvInputString.components(separatedBy: "\n")
      guard lines.isEmpty == false else { return [] }
      
      let columnNames = optionalColumnNames ?? lines[0].components(separatedBy: "\t")
      var lineIndex = (optionalColumnNames != nil) ? 0 : 1
      let columnCount = columnNames.count
      var result = Array<NSDictionary>()
      
      for line in lines[lineIndex ..< lines.count] {
        let fieldValues = line.components(separatedBy: "\t")
        if fieldValues.count != columnCount {
          //      NSLog("WARNING: header has %u columns but line %u has %u columns. Ignoring this line", columnCount, lineIndex,fieldValues.count)
        }
        else
        {
            result.append(NSDictionary(objects: fieldValues, forKeys: columnNames as [NSCopying]))
        }
        lineIndex = lineIndex + 1
      }
      return result
    }
    
    public func shuffleCards(){
        //pegar todas as cartas originais
        var shuffledCards = GameEnvironment.originalCards.shuffled()
        
        //adicionar apenas uma carta de bloqueamento
        let blockCard = GameEnvironment.blockCards.randomElement()!
        blockEndingText = GameEnvironment.blockEndings[blockCard.id]
        
        shuffledCards.append(blockCard)
        shuffledCards.shuffle()
        
        //limpar para ter apenas 13 cartas de jogo
        shuffledCards.removeLast(shuffledCards.count - 15)
        
        //se o ultimo for o block da o shuffle de novo
        while shuffledCards.last == blockCard{
            shuffledCards.shuffle()
        }
        
        //adicionar cartas iniciais
        if !UserDefaults.standard.bool(forKey: "has_completed_onboarding_once_key"){
            shuffledCards.insert(contentsOf: GameEnvironment.onboardingCards.reversed(), at: shuffledCards.count)
        }
        else{
            shuffledCards.insert(GameEnvironment.onboardingCards[0], at: shuffledCards.count)
        }

        
        for i in 0 ..<  shuffledCards.count {
            shuffledCards[i].id = i
        }
        self.cards = shuffledCards // Colocando caso tenha algum local do código que pegue diretamente de CardData().cards
        self.maxID = shuffledCards.count - 1
        
        self.objectWillChange.send()
    }

    
    static var originalCards: [Card] = [
        Card(id: 0, cardImage: UIImage(named: "XeroV1_Ilu_19Sede")!, cardName: "Tá com Sede?", cardText: "Eita, calor tá grande demais. Tu tais lembrando de beber água? Trata de fazer algo que tu não vai aguentar assim.", leftOption: "Beber água", rightOption: "Tirar a camisa", leftAnswer: "Bebeu água, não \n Tá com sede, tô \n Olha, olha, olha, olha a água mineral \n Água mineral \n Água mineral \n Água mineral \n Do Candeal \n Você vai ficar legal", rightAnswer: "Lá vai a biscoiteira tirando a camisa pra chamar atenção dos boys... Mas tu não se lembra de passar o protetor solar nunca, né? Em resumo, ficou todo queimado, desidratou e terminou com uma insolação. Bebe água, menino!", leftStatus: [2, -2, -1], rightStatus: [-3, 0, -3]),
        Card(id: 2, cardImage: UIImage(named: "XeroV1_Ilu_15Pirata")!, cardName: "O Pirata", cardText: "Você olha pro lado e vê um pirata chegando em você. Com tapa olho, bigode enroladinho e uma cara de mal. Eita, olha o tamanho da espada dele... Vai andar na prancha ou vai se entregar ao perigo?", leftOption: "Andar na prancha", rightOption: "AHOY!", leftAnswer: "O pirata parecia perigoso demais e você preferiu pular daquele barco. Agora é esperar outro marujos cairem nos seus encantos de sereia. Mas espera, o que é aquilo ali no chão? Será que o pirata derrubou o fruto da sua pirataria? Achasse 30 reais no chão!", rightAnswer: "O pirata vem e lhe dá um beijão. Você sente ele apalpando todo seu corpo, você fica enlouquecido. Vocês passam um bom tempo se beijando, mas ele sai quase sem falar nada. Espera, não tá sentindo seu bolso leve demais? Amigo, acho que além de roubar seu coração, ele roubou junto a sua carteira...", leftStatus: [0, 2, 0], rightStatus: [-2, -3, 0]),
        Card(id: 3, cardImage: UIImage(named: "XeroV1_Ilu_14bloco_da_lama")!, cardName: "O Bloco da Lama", cardText: "Eita, olha a galera chegando do bloco da lama. Tá todo mundo coberto de lama dos pés a cabeça. E lá vem uma amiga tua, calma ela está querendo te abraçar?", leftOption: "Abraçar a amiga", rightOption: "Falar de longe", leftAnswer: "Ai, menino, é carnaval, bora se melar também. Afinal, lama não é bom para a pele? Você se abraçam e vc se mela todinho. Eita, mas cadê aquele boyzinho que você estava trocando olhares? Acho que ele correu quando te viu melado. Pelo menos tua pele vai ficar hidratada, né?", rightAnswer: "Sua amiga vem te abraçar, mas vc fala de longe mesmo. Melhor não se melar, né? Ela fala algumas vezes como você é sem graça e que deveria se divertir mais. Por falar em diversão, o boy que estava trocando olhares com você está chegando perto. Que tal se divertir com ele?", leftStatus: [2, 0, -1], rightStatus: [1, 0, 0]),
        Card(id: 4, cardImage: UIImage(named: "XeroV1_Ilu_13selfie")!, cardName: "Tira uma Selfie", cardText: "Você junta a galera pra tirar aquela selfie com cara de acabado digna de todo bom Carnaval. Todo mundo troncho, rindo um bocado. Agora guarda o celular!", leftOption: "Celular na pochete", rightOption: "Celular na doleira", leftAnswer: "Você guarda o celular na pochete. Mas logo começa um empurra empurra. Vocês correm pro canto. Mas calma, cadê sua pochete? Eita, boy, fosse assaltado. Ainda bem que ainda tens um dinheiro na doleira. Pelo menos conseguisse registrar a foto maravilhosa nos stories.", rightAnswer: "Você guardou o celular na doleira. Você passa tranquilo por todo o empurra empurra, sem medo de ser assaltado. Você segue então brincando e um de seus amigos oferece o Axé que acabou de comprar.", leftStatus: [-2, -3, 0], rightStatus: [1, 0, 1]),
        Card(id: 5, cardImage: UIImage(named: "XeroV1_Ilu_12Escadaria")!, cardName: "A Escadaria", cardText: "Você vê uma amiga sua que faz tempo que não vê lá no alto da escadaria curtindo uma fritação. Corre lá pra falar com ela antes de perder ela de vista.", leftOption: "Enfrentar fila", rightOption: "Enfrentar lama", leftAnswer: "Você tenta subir os caminhos da escadaria, mas eles estão cheio de gente. Com a demora pra conseguir subir, você perde sua amiga de vista. Pra não perder a viagem, você resolve parar em uma das barracas pra lanchar e tomar uma água. Quem sabe vocês não se esbarram em outro carnaval?", rightAnswer: "Você vai pelo caminho mais difícil, mas consegue subir bem mais rápido e chega na sua amiga. Vocês se abraçam, contam as fofocas e aproveitam para provar aquele pirulito verde. Ela ainda te apresenta um amigo, gatinho ele. Vocês trocam uns olhares, ele elogia sua fantasia e acaba saindo um beijão.", leftStatus: [2, -3, -2], rightStatus: [1, 0, 2]),
        Card(id: 6, cardImage: UIImage(named: "XeroV1_Ilu_11Roda_Beck")!, cardName: "A Roda de Pirulito", cardText: "Tu vai encontrar aquele contatinho que estava esperando ali no canto da ladeira. Fofo todo, ele comprou pra ti um pirulito verde. O problema é que teus amigos querem também, mas só tem dois... E agora?", leftOption: "Repartir o pão", rightOption: "Credo, que nojo!", leftAnswer: "Os pirulitos passam um pra cada lado, de boca em boca. Com essa troca toda de saliva é capaz de tu criar mais imunidade (Será?!!). De qualquer forma, esses pirulitos não dão nem pro gasto.", rightAnswer: "No carnaval, a gente pega muitas coisas (até quem não deve), mas sapinho não, né gente?! O povo fica chateado e fica um clima estranho, mas tu resolve comprando pirulito pra todo mundo.", leftStatus: [-1, 0, 3], rightStatus: [-2, 0, -3]),
        Card(id: 7, cardImage: UIImage(named: "XeroV1_Ilu_10Encontro_Blocos")!, cardName: "Encontro de Blocos", cardText: "Você está no meio do aperto da 13 quando ouve o bater de um surdo vindo das suas costas. Mas calma, lá na frente não tá vindo um bloco? Certeza que esses dois blocos vão se esbarrar bem onde você está.", leftOption: "Se imprensar", rightOption: "Esperar os blocos", leftAnswer: "Você se imprensa com o pessoal nas barracas nas beiras da rua. É um empurra empurra danado, mas você aproveita pra comprar uma garrafa de água. Eita, aquele boyzinho tá olhando pra você. Eita, que ele tá vindo. Chegou com uma pala, mas tu já ficasse todo animado. Beija logo e aproveita!", rightAnswer: "Bicha, a senhora é afrontosa, viu? Vai ficar esperando os blocos chegarem? Os blocos chegam, a rua vira uma festa e tu tá bem no meio! Todo mundo se divertindo e vendo você dançar frevo pra se acabar! A festa está toda a sua volta, se joga que Carnaval é pra isso mesmo! Ah, só não esquece de beber água depois!", leftStatus: [1, -2, 0], rightStatus: [2, 0, 0]),
        Card(id: 8, cardImage: UIImage(named: "XeroV1_Ilu_9Cade_Povo")!, cardName: "Eita, Cadê o Povo?", cardText: "Você olha para um lado, olha pro outro e só vê a multidão no empurra empurra. Onde foram parar os teus amigos? E agora, como vai encontrar eles? Vocês marcaram algum ponto de encontro?", leftOption: "Subir a escadaria", rightOption: "Ir pro MAC", leftAnswer: "Você resolve subir a escadaria para poder olhar do alto. Mas tá uma confusão da gota! É gente, é bicho, é barraca, é barranco... Cuidado pra não tropeçar naquele bu... Tarde demais, caísse e se melasse todinho na lama. Agora tais perdido e todo cagado.", rightAnswer: "Como todo ano, tu já sabe, se perdeu corre pro MAC. Você vai se debatendo no meio do povo, se imprensando no meio das filas. De repente, você vê o cabelo colorido do seu amigo. E vê que chique, eles já te recepcionam com uma poção da alegria e água geladinha.", leftStatus: [-2, -1, -2], rightStatus: [2, 0, 1]),
        Card(id: 9, cardImage: UIImage(named: "XeroV1_Ilu_8Aquilo_e_Doce")!, cardName: "Aquilo é Jujuba?", cardText: "Tu e teu amigo estão subindo as escadarias quando ele encontra um pacotinho de doces largado no chão. Parece que dentro dele tem ursinhos de gelatina!", leftOption: "Colocar na boca", rightOption: "Deixar no chão", leftAnswer: "Ei, ooo que tt acc conte sendo? 4s CoZax tt04 1/2 Ex tttttrrrr ãããããããããã nH4z. EEEiEiiiaifo, vvoou C T4 wW3ell? 4Xho Ki é BbBoOm nN User eSsasSs coooo us4sS 100 Xab3R D1 0nD véio\nEh drègui ihhhhhhhh", rightAnswer: "Você provavelmente fez a melhor escolha. É bom saber a procedência do que você está colocando do seu corpo, não é? Se tu quer tanto um docinho, aquele boy tá vendendo pirulito verde, corre lá pra comprar!", leftStatus: [-1, 0, 3], rightStatus: [1, -3, 1]),
        Card(id: 10, cardImage: UIImage(named: "XeroV1_Ilu_7Onde_Fica_Banheiro")!, cardName: "Onde Fica o Banheiro?", cardText: "Eita, que tais doido pra mijar, não é? Corre atrás de um canto logo, que aquele Axé tá doido pra sair. Mas e aí, onde é que faz xixi no carnaval?", leftOption: "Mijar no beco", rightOption: "Banheiro químico", leftAnswer: "Corresse pro beco, já encontrasse uma vaga e o xixi já tá saindo e escorrendo pelas ladeiras de Olinda. Mas é bom sair do aperto, né? Calma, ali no cantinho é uma nota de 10 reais?", rightAnswer: "Boy, a fila dos banheiros da 13 estão enormes. E os banheiros já estão querendo transbordar... Desse jeito você não vai aguentar, melhor correr e pagar 2 reais pra fazer xixi naquela casa. Lembrando que dois reais é só o número 1, o número 2 é mais caro...", leftStatus: [3, 2, -2], rightStatus: [2, -2, -3]),
        Card(id: 11, cardImage: UIImage(named: "XeroV1_Ilu_6Diabo_Loiro")!, cardName: "Um Diabo Loiro", cardText: "Um diabo louro faiscou na minha frente/ Com cara de gente, bonito demais/ Chegou de bobeira, marcando zoeira no meio da praça/ Quebrando vidraças, isto não se faz", leftOption: "Foi paranóico", rightOption: "Me fez sedento", leftAnswer: "Será que o boy tá me olhando? Será que eu chego nele? Será que eu tô com muita cara de doido? Será que ele está olhando pra outra pessoa? Que rolê é esse? De onde veio toda essa gente? Acho que você está ficando noiado...", rightAnswer: "Bicha, que boy é esse? Tais doida pra dar uns beijos. Mas calma lá, ele tá beijando uma boyzinha? Eita, tá beijando um boyzinho também! Tais sedento pra ser o próximo, né? Mas esse diabo já faiscou novamente e sumiu no meio da multidão. Agora só próximo carnaval.", leftStatus: [-3, -1, 2], rightStatus: [-1, 0, 0]),
        Card(id: 12, cardImage: UIImage(named: "XeroV1_Ilu_22Vadia_todoDia")!, cardName: "Vadia todo dia", cardText: "Eu não espero o carnaval chegar pra ser vadia\nSou todo dia\nMas no carnaval, és mais né, more?\nHá pouco tempo desviasse do teu ex e tais ficando muito loko. Opa! Ali é meu crush supremo?  Tu vai falar com ele? Teu ex ta de olho... ", leftOption: "Falar com o crush", rightOption: "Deixar pra lá", leftAnswer: "Passado é passado meu ex que lute! Tu chega no crush se sentindo todo todo \"Gato, você é carnavalesco? Porque eu tenho certeza de que você vai realizar minha fantasia\"\nO boy não resiste à cantada e finalmente teu sonho se realiza. Quem sabe agora não está na hora de realizar outras fantasias?", rightAnswer: "Querendo evitar b.o, tu não fala com o crush, ficando só na esperança de esbarrar com ele depois...\nNessa brincadeira acabasse o Axé da tua amiga e agora vais ter que comprar mais. Saísse dessa de coração partido e ainda mais liso. Te prioriza, homem!", leftStatus: [2, 0, -1], rightStatus: [-2, -1, 0]),
        Card(id: 13, cardImage: UIImage(named: "XeroV1_Ilu_23Ressuscita")!, cardName: "Bumbum de ouro ou Ressucita", cardText: "As mil ladeiras de Olinda, tu rebolando a raba por horas!\nAi que deli!\nTeu bumbum ta ficando maravigold, mas estás tuas pernas tão quase pedindo arrego...\nRESSUSCITA!", leftOption: "Comer bala", rightOption: "Tomar Refri", leftAnswer: "Tu come a balinha de pitomba que tinhas levado pra dar aquela animada. E não é que funcionou? Tas novo! até parece que o carnaval começou agora. EITA que ta tocando uma fritação de carnaval ali em cima. AAAAAAAH quanta energia vou me jogar * - *", rightAnswer: "Tu compra um refri geladinho (dentro do possível, ne?) e o açúcar dá uma ajudada, mas o cansaço ainda tá grande. Melhor dar uma respirada pra sobreviver o resto do carnaval. Tu arruma um cantinho na sombra pra sentar e tomar o refri em paz.", leftStatus: [-2, 0, 3], rightStatus: [2, -1, 0]),
        Card(id: 14, cardImage: UIImage(named: "XeroV1_Ilu_20Chuva")!, cardName: "Olha a chuva!", cardText: "E não é que tu tava curtindo a fritação e o céu fechou de repente?! Cade aquele solzão de minutos antes?\nBoy, corre que vai cair um toró daqueles!", leftOption: "Já já passa", rightOption: "A make vai borrar!", leftAnswer: "Nada como uma chuva pra refrescar aquele fogo, o seu e o da 13. Perfeito pra tu que tava torrando desde cedinho.\nEita, que aquele boy tá vindo, será que rola aquele beijo romântico?", rightAnswer: "Eita, tem um toldo ali na frente! Tu corre, mas não foi o único. Uma galera teve a mesma ideia.\nEmpurra-empurra, pisão no pé. Agora é ficar ai imprensado até a chuva passar. Pelo meus tua amiga comprou aquele Axé geladinho pra ajudar na espera!", leftStatus: [1, 0, -1], rightStatus: [-2, 0, 2])
    ]
    
    static let blockCards: [Card] = [
        
        Card(id: 0, cardImage: UIImage(named: "XeroV1_Ilu_16Ele_quer")!, cardName: "Será que Ele Quer?", cardText: "Você vai chegar em um boy que estava trocando olhares com você, mas ele fala com jeitinho que não esta a fim. Será que isso é apenas timidez?", leftOption: "Insistir em beijar", rightOption: "Voltar pros amigos", leftAnswer: "Insistir em beijar alguém não é brincadeira de Carnaval, é assédio. Então, aprende a respeitar o espaço do outro e que as pessoas podem não estar a fim. Não é não e ponto final. Vê se deixa de escrotisse no próximo carnaval.", rightAnswer: "Você sabe muito bem que Não é Não. Agora fica tranquilo e continua curtindo teu Carnaval, que ainda tem muita coisa boa pra acontecer. Compra um Axé, chama os amigos e segue o bloco!", leftStatus: [-10, -10, -10], rightStatus: [3, 0, 1]),
        Card(id: 1, cardImage: UIImage(named: "XeroV1_Ilu_18Fantasia")!, cardName: "E essa fantasia aí?", cardText: "Ta vindo ali, subindo a ladeira/ um boyzinho que vê no carnaval só folia / Se fantasiou de mulher, achando que é zueira / Menino, tu não ja sabe que identidade não é brincadeira? Respeita!", leftOption: "Conversar sobre", rightOption: "Relaxa, é carnaval!", leftAnswer: "Tu sugeriu pro boy outras fantasias pra curtir melhor no ano seguinte. É carnaval e, provavelmente, ele não vai te escutar. Mas não custa tentar!", rightAnswer: "Século 21 e tu ainda reforçando os esteriótipos de gênero?! Só para tu saber também não é fantasia índio, cigano, Iemanjá, padre ou muçulmano. Te orienta!", leftStatus: [3, 0, -2], rightStatus: [-10, -10, -10]),
        Card(id: 2, cardImage: UIImage(named: "XeroV1_Ilu_17Gaia")!, cardName: "É gaia?", cardText: "Olha quantos gatinhos vindo naquela fila ali na frente... Calma, aquele ali não é o atual do teu amigo? Pera aí, ele tá beijando uma menina! Eles tem um relacionamento aberto, mas será que seria bom avisar?", leftOption: "Contar pro amigo", rightOption: "Ficar de boa", leftAnswer: "Tu fica revoltado e vai logo atrás do teu amigo mostrando o namorado dele beijando a menina.  Mas é claro que teu amigo te deu logo um fora, o menino não tem um relacionamento aberto? E o que é que tem se o namorado dele também beija meninas? Agora paga um pirulito verde pra teu amigo e pede desculpas, porque julgar a sexualidade alheia é preconceito. Melhora, visse?", rightAnswer: "Você fica de boa e deixa o namorado do seu amigo beijar em paz, afinal ele tem um relacionamento aberto, não é mesmo? Inclusive, olha ali teu amigo beijando um boyzinho tbm. Calma, teu amigo tá vindo com o boy até você? Hummm... Olha o que isso tem cara de beijo triplo.\nVocê dá um gole de Axé e vocês três se enroscam e se beijam ao mesmo tempo, afinal, que forma melhor tem de fortalecer uma amizade no carnaval do que beijar um boy junto? ", leftStatus: [-10, -10, -10], rightStatus: [2, 0, 1])
        
    ]
    
    static let blockEndings: [String] = [
        "Assédio não é brincadeira. Aqui é só um jogo, mas para assédio não existe espaço em nenhum lugar. Você foi cancelado!",
        "Não é mais tempo de ficar reforçando qualquer tipo de estereótipo, dentro ou fora de jogo, viu?! Você foi cancelado!",
        "Já tá na hora de perder esses teus preconceitos, não é? Afinal, preconceito bom é aquele que não existe, nem em jogo. Você foi cancelado!"
        
    ]
    
    static let onboardingCards: [Card] = [
        Card(id: 0, cardImage: UIImage(named: "XeroV1_Ilu_1despertador")!, cardName: "Levanta, gay, bora Olindar!", cardText: "Vai, João, levanta que tens que decidir em como se arrumar!\nSe tu deslizar pra um lado que você se fantasia, desliza pro outro que você vai arrumadinho. Mas vai com calma, desliza devagar pra ver as opções aparecendo na tela.", leftOption: "Vista a Fantasia", rightOption: "Vá Arrumadinho", leftAnswer: "Você colocou uma fantasia babado e tô vendo que esse carnaval vai render, viu?\nAgora Carnaval não é época só de se fantasiar não, mas de realizar fantasias tbm, viu? Só não esquece que a gente realiza fantasias mas com respeito e consentimento. Agora corre pra Olinda", rightAnswer: "Se arrumou todo pra Olinda?\nTá esperando encontrar uns boys pra te bagunçarem por lá? Correto! Mas olhe, vá com cuidado, respeito e consentimento que esse carnaval vai ser tudo! Certeza que tu vai acabar encontrando vários crushes das prévias por lá...", leftStatus: [ 0, 0, 0], rightStatus: [ 0, 0, 0]),
        Card(id: 1, cardImage: UIImage(named: "XeroV1_Ilu_2Atributos")!, cardName: "Se cuida, visse?", cardText: "Pegasse o ônibus e já tais entrando no clima, né? Agora não esquece que lá em cima estão teus atributos de saúde, dinheiro e insanidade. O carnaval só tá começando e se não se cuidar, é fim de festa...", leftOption: "Olhar pela Janela", rightOption: "Cantar com o povo", leftAnswer: "Oxi, menino, ficasse preocupado, foi? Fica tranquilo que carnaval é pra se jogar mesmo. Só ficar ligado que cada uma das suas escolhas tem consequências que podem aumentar ou diminuir seus atributos. Só não deixa a saúde e o dinheiro chegarem a zero ou a insanidade chegar ao máximo, que tens que sobreviver. Mas vai curtir que carnaval só tem uma vez por ano (quando tem, né?)", rightAnswer: "Popopopó pó pó!\nCarnaval é isso: se joga e vai curtir a festa! Só ficar ligado que cada uma das suas escolhas tem consequências que podem aumentar ou diminuir seus atributos. Só não deixa a saúde e o dinheiro chegarem a zero ou a insanidade chegar ao máximo, que tens que sobreviver. Mas vai curtir que carnaval só tem uma vez por ano (quando tem, né?)", leftStatus: [ 0, 0, 0], rightStatus: [ 0, 0, 0]),
        Card(id: 2, cardImage: UIImage(named: "XeroV1_Ilu_3TrezeMaio")!, cardName: "Tais na 13?", cardText: "Sábado de carnaval e tu chegando todo na se querência nas ladeiras de Olinda. É sol, é calor e empurra-empurra, mas logo você chega na 13 de Maio, a rua mais LGBT+ do Carnaval de Olinda", leftOption: "Empurra pra um lado", rightOption: "Empurra pro outro", leftAnswer: "É gente demais, mas é um empurra-empurra gostoso, né? Agora se liga que muita coisa vai acontecer por aqui ao longo desse e de outros carnavais. E nem te preocupa, sempre vai ter uma história nova pra você seguir ao longo do dia. Afinal, nunca se sabe onde tuas escolhas vão te levar... Cuidado, não...", rightAnswer: "É gente demais, mas é um empurra-empurra gostoso, né? Agora se liga que muita coisa vai acontecer por aqui ao longo desse e de outros carnavais. E nem te preocupa, sempre vai ter uma história nova pra você seguir ao longo do dia. Afinal, nunca se sabe onde tuas escolhas vão te levar... Cuidado, não...", leftStatus: [ 0, 0, 0], rightStatus: [ 0, 0, 0]),
        Card(id: 3, cardImage: UIImage(named: "XeroV1_Ilu_4xero")!, cardName: "Poção da Alegria", cardText: "Eita, ali não é teu amigo? Que lata é essa que ele tá te dando. Menino, essa é uma Poção da Alegria Enlatada! Daquelas que vc tem que balançar antes de usar. Guarda aí e quando quiser usar, basta balançar o aparelho que é sucesso!", leftOption: "Se jogar na 13", rightOption: "Cadê os crushes?", leftAnswer: "A animação tá lá em cima e o coração batendo forte ao som das alfaias! O carnaval está começando e tu não tem ideia do que está pela frente, mas vai ser massa!\nAgora só não exagera na Poção da Alegria, porque se a insanidade for aumentando, a visão acaba embaçada, viu?", rightAnswer: "Mas tu só pensa em beijar, mas tá errado? Carnaval é pra se divertir e pra conhecer novas pessoas e bocas! Entra na farra que tem muito pra acontecer ainda e certeza que vai ser muito massa. Agora só não exagera na Poção da Alegria, porque se a insanidade for aumentando, a visão acaba embaçada, viu?", leftStatus: [ 0, 0, 0], rightStatus: [ 0, 0, 0])
    ]
    
}

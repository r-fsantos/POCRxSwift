//
//  ViewController.swift
//  POCRxSwift
//
//  Created by Renato F. dos Santos Jr on 03/03/23.
//

import UIKit
import RxSwift
import RxRelay

// MARK: - Fluxo de Dados
/// onNext - emitido um novo valor
/// onCompleted - fluxo encerrado com sucesso
/// onError - fluxo encerrado com erro
/// onDipose - deallocação de memória do observable/observer

final class ViewController: UIViewController {

    // MARK: - A referência DisposeBag deve ser a mesma que guarda as referências de observer/observable
    /// Quando a ViewController for desalocada, ira desalocar os observers/observables e também a disposeBag
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        title = "POCRxSwift"

        //        traits()
        observables()
    }

    private func traits() {
        testingSingleTrait(withDisposeBag: disposeBag)
        testingCompletableTrait(withDisposeBag: disposeBag)
        testingMaybeTrait(withDisposeBag: disposeBag)
    }

    private func observables() {
        // Emissão de vários eventos
        //        testingPublishSubject(withDisposeBag: disposeBag)
//        testingBehaviorSubject(withDiposeBag: disposeBag)
        testingReplaySubject(withDisposeBag: disposeBag)

    }

}

// MARK: PublishSubject
extension ViewController {

    // PublishSubject
    /// `Repassa apenas os valores emitidos após o registro ao Observável`
    /// `Não armazena os eventos, apenas emite/repassa.`
    func testingPublishSubject(withDisposeBag disposeBag: DisposeBag) {
        let publishObservable = PublishSubject<String>()

        publishObservable.subscribe(onNext: { string in
            print("publishObservable onNext: \(string)")
        }, onError: { error in
            print("publishObservable onError: \(error.localizedDescription)")
        }, onCompleted: {
            print("publishObservable onCompleted")
        }).disposed(by: disposeBag)

        print("Type of publishObservable: ", type(of: publishObservable))

        publishObservable.onNext("primeiro elemento")
        publishObservable.onNext("segundo elemento")
        publishObservable.onNext("terceiro elemento")
        publishObservable.onNext("quarto elemento")

        publishObservable.onCompleted()
        publishObservable.onError("Erro!")
    }

}

// MARK: BehaviorSubject
extension ViewController {

    /// `Emite o último valor e valores subsequentes`
    func testingBehaviorSubject(withDiposeBag disposeBag: DisposeBag) {
        let behaviorObservable = BehaviorSubject<String>(value: "ELEMENTO ZERO")

        behaviorObservable.onNext("SOBRESCREVE O ELEMENTO ZERO")

        behaviorObservable.subscribe(onNext: { string in
            print("behaviorObservable onNext: \(string)")
        }, onError: { error in
            print("behaviorObservable onError: \(error.localizedDescription)")
        }, onCompleted: {
            print("behaviorObservable onCompleted")
        })
            .disposed(by: disposeBag)

        behaviorObservable.onNext("primeiro elemento")
        behaviorObservable.onNext("segundo elemento")
        behaviorObservable.onNext("terceiro elemento")
        behaviorObservable.onNext("quarto elemento")

        behaviorObservable.onCompleted()
        behaviorObservable.onError("Erro!")

        let value = try? behaviorObservable.value()
        print("Value:", value ?? "empty")
    }

}

// MARK: - ReplaySubject
extension ViewController {

    /// `Possui um buffer com tamanho específico, que pode ser sobrescrito.
    /// `Objetos que se registram recebem os valores atuais do buffer e os subsequentes.`
    /// `Atenção que é guardado ANTES do SUBSCRIBE`
    func testingReplaySubject(withDisposeBag disposeBag: DisposeBag) {
        let replayObservable = ReplaySubject<String>.create(bufferSize: 2)

        replayObservable.onNext("primeiro elemento")
        replayObservable.onNext("segundo elemento")
        replayObservable.onNext("terceiro elemento")
        replayObservable.onNext("quarto elemento")

        replayObservable.subscribe(onNext: { string in
            print("replayObservable onNext: \(string)")
        }, onError: { error in
            print("replayObservable onError: \(error.localizedDescription)")
        }, onCompleted: {
            print("replayObservable onCompleted")
        }).disposed(by: disposeBag)

        replayObservable.onNext("quinto elemento")

        replayObservable.onCompleted()

    }
}

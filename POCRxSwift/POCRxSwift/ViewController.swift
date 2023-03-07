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

        // MARK: - PublishSubject
        /// `Repassa apenas os valores emitidos após o registro ao Observável`
        /// `Não armazena os eventos, apenas emite/repassa.`
        let publishObservable = PublishSubject<String>()

        publishObservable.subscribe(onNext: { string in
            print("publishObservable onNext: \(string)")
        }, onError: { error in
            print("publishObservable onError: \(error.localizedDescription)")
        }, onCompleted: {
            print("publishObservable onCompleted")
        }).disposed(by: disposeBag)

        publishObservable.onNext("primeiro elemento")
        publishObservable.onNext("segundo elemento")
        publishObservable.onNext("terceiro elemento")
        publishObservable.onNext("quarto elemento")

        // MARK: - BehaviorSubject
        /// `Emite o valor inicial e valores subsequentes`
        //        BehaviorSubject()

        // MARK: - ReplaySubject
        /// `Possui um buffer com tamanho específico, que pode ser sobrescrito.
        /// `Objetos que se registram recebem os valores atuais do buffer e os subsequentes.`
        //        ReplaySubject()
//        PublishRelay()
    }

}

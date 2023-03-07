//
//  ViewController.swift
//  POCRxSwift
//
//  Created by Renato F. dos Santos Jr on 03/03/23.
//

import UIKit
import RxSwift

// MARK: - Fluxo de Dados
/// onNext - emitido um novo valor
/// onCompleted - fluxo encerrado com sucesso
/// onError - fluxo encerrado com erro
/// onDipose - deallocação de memória do observable/observer

// MARK: - Traits: Características de observáveis
///
/// `Produzem apenas um elemento. Ou emitem completed, erro
/// `ou seja, não podem ser usados em fluxos/streams complexos.`
///
/// `Single: Emite apenas um único elemento ou erro.`
///     Ex: Integração com API. Execução async (Success, Error).
///     Não tem side effects, para outros observáveis. excelente
///
/// `Completable: Não emite valores. Apenas completude ou erro. Doesn't share side effects.`
///     onCompleted
///     Ex: Cache. Vc só precisa saber se deu sucesso ou falha!
///
/// `Maybe: Pode emitir
///     `um elemento ou não!`
///     `onCompleted`
///     `onError`
///     Ex: Não é muito utilizado, mas saibamos que existe
///

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        title = "POCRxSwift"

        // testing traits
        createsSingleTrait()
        createsCompletableTrait()
        createsMaybeTrait()
    }

}

// MARK: - Single Trait. Observar sua assinatura, comportamento e retorno.
private extension ViewController {

    private func createsSingleTrait() {
        let singleObservable = Single<String>.create { single in
            single(.success("Deu bom"))

            // Dúvida!
            return Disposables.create()
        }

        _ = singleObservable.subscribe(onSuccess: { print("Single: onSuccess: \($0)") },
                                       onFailure: { print("Single: onFailure: \($0)") },
                                       onDisposed: { print("Single: onDisposed") })
    }

}

// MARK: - Completable Trait
private extension ViewController {

    private func createsCompletableTrait() {
        let completableObservable = Completable.create { completable in
            completable(.completed)

            return Disposables.create()
        }

        _ = completableObservable.subscribe(
            onCompleted: { print("Completable: onCompleted") },
            onError: { error in print("Completable: onError: \(error.localizedDescription)") },
            onDisposed: { print("Completable: onDisposed") }
        )
    }

}

// MARK: - Maybe Trait
private extension ViewController {

    private func createsMaybeTrait() {
        let maybeObservable = Maybe<String>.create { maybe in
            maybe(.success("Deu bom no Maybe"))

            maybe(.completed)

            let someError = NSError(domain: "Maybe trait", code: 1)
            maybe(.error(someError))

            return Disposables.create()
        }
        _ = maybeObservable.subscribe(onSuccess: { print("Maybe: onSuccess: \($0)") },
                                      onError: { error in print("Maybe: onError \(error.localizedDescription)") },
                                      onCompleted: { print("Maybe: onCompleted") },
                                      onDisposed: { print("Maybe: onDisposed") })
    }

}

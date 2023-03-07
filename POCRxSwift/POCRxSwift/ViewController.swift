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
///     Ex: Integração com API. Execução async (Success, Failure).
///     Não tem side effects, para outros observáveis. excelente
///
/// `Completable: Não emite valores. Apenas completude ou error. Doesn't share side effects.`
///     onCompleted
///     Ex: Cache. Vc só precisa saber se deu sucesso ou falha!
///
/// `Maybe: Pode emitir
///     `um elemento ou não!`
///     `onCompleted`
///     `onFailure`
///     Ex: Não é muito utilizado, mas saibamos que existe
///

final class ViewController: UIViewController {

    // MARK: - A referência DisposeBag deve ser a mesma que guarda as referências de observer/observable
    /// Quando a ViewController for desalocada, ira desalocar os observers/observables e também a disposeBag
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        title = "POCRxSwift"

        traits()
    }

    private func traits() {
        testingSingleTrait()
        testingCompletableTrait()
        testingMaybeTrait()
    }

}

private extension ViewController {
    // MARK: - Creating a Single Trait
    private func fetchSingleTrait() -> Single<String> {
        Single<String>.create { single in
            single(.success("Deu bom"))

            //            let error = NSError(domain: "Deu ruim", code: 0)
            //            single(.failure(error))

            // Dúvida!
            return Disposables.create()
        }

    }

    // MARK: - Testing Single Trait
    private func testingSingleTrait() {
        _ = fetchSingleTrait().subscribe(onSuccess: { print("Single: onSuccess: \($0)") },
                                         onFailure: { print("Single: onFailure: \($0)") },
                                         onDisposed: { print("Single: onDisposed") })

        print("=========================================================")

        fetchSingleTrait().subscribe(onSuccess: { string in
            print("Single with disposeBag: onSuccess: \(string)")
        }, onFailure: { failure in
            print("Single with disposeBag: onFailure: \(failure.localizedDescription)")
        }).disposed(by: disposeBag)
    }

}

private extension ViewController {
    // MARK: - Creating a Completable Trait
    private func fetchCompletableTrait() -> Completable {
        Completable.create { completable in
            completable(.completed)

            return Disposables.create()
        }
    }

    // MARK: - Testing a Completable Trait
    private func testingCompletableTrait() {
        _ = fetchCompletableTrait().subscribe(
            onCompleted: { print("Completable: onCompleted") },
            onError: { error in print("Completable: onError: \(error.localizedDescription)") },
            onDisposed: { print("Completable: onDisposed") }
            )

        print("=========================================================")

        fetchCompletableTrait().subscribe(onCompleted: {
            print("Completable with disposeBag: onCompleted")
        }, onError: { error in
            print("Completable with disposeBag: onError: \(error.localizedDescription)")
        }).disposed(by: disposeBag)
    }

}

// MARK: - Maybe Trait
private extension ViewController {

    // MARK: - Creating a Maybe Trait
    private func fetchMaybeTrait() -> Maybe<String> {
        Maybe<String>.create { maybe in
            maybe(.success("Deu bom no Maybe"))

            maybe(.completed)

            let someError = NSError(domain: "Maybe trait", code: 1)
            maybe(.error(someError))

            return Disposables.create()
        }
    }

    // MARK: - Testing a Maybe Trait
    private func testingMaybeTrait() {
        _ = fetchMaybeTrait().subscribe(onSuccess: { print("Maybe: onSuccess: \($0)") },
                                      onError: { error in print("Maybe: onError \(error.localizedDescription)") },
                                      onCompleted: { print("Maybe: onCompleted") },
                                      onDisposed: { print("Maybe: onDisposed") })

        print("=========================================================")

        fetchMaybeTrait().subscribe(onSuccess: { string in
            print("Maybe with disposeBag: onSuccess: \(string)")
        }, onError: { error in
            print("Maybe with disposeBag: onError: \(error.localizedDescription)")
        }, onCompleted: {
            print("Maybe with disposeBag: onCompleted")
        }).disposed(by: disposeBag)

    }

}

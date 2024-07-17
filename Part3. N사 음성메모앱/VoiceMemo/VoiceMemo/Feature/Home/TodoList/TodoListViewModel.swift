//
//  TodoListViewModel.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var isEditTodoMode: Bool
    @Published var removeTodos: [Todo]  // 삭제예정 todo를 담아주는 배열
    @Published var isDisplayRemoveTodoAlert: Bool  // alert을 호출하는 플래그 변수
    
    // 알럿에서 n개를 삭제할지 나타내기 때문에 count해주는 계산속성 필요
    var removeTodosCount: Int {
        return removeTodos.count
    }
    
    // 네비게이션바가 어떤 case인지
    var navigationBarRightBtnMode: NavigationBtnType {
        isEditTodoMode ? .complete : .edit
    }
    
    init(
        todos: [Todo] = [],
        isEditModeTodoMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditTodoMode = isEditModeTodoMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}


// MARK: - 비지니스 로직
extension TodoListViewModel {
    /// todo 리스트가 체크(완료) 되었을 때 액션
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo }) {
            todos[index].selected.toggle()
        }
    }
    
    /// Todo 생성했을 때 액션
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    /// 네비게이션바 오른쪽 버튼 눌렸을 때 액션
    func navigationRightBtnTapped() {
        if isEditTodoMode {  // edit 모드일 때,
            if removeTodos.isEmpty {
                isEditTodoMode = false
            } else {
                setIsDisplayRemoveTodoAlert(true)  // 알럿 부르기
            }
        } else {
            isEditTodoMode = true
        }
    }
    
    func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }
    
    /// Todo를 삭제하는 박스를 선택했을 때 액션
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {  // 선택된 것을 또 선택했을 때
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }
    
    /// 삭제 버튼 눌렀을 때
    func removeBtnTapped() {
        todos.removeAll { todo in  // removeTodos에 todo가 있으면 삭제
            removeTodos.contains(todo)
        }
        removeTodos.removeAll()  // removeTodos 초기화
        isEditTodoMode = false  // 에딧모드
    }
}

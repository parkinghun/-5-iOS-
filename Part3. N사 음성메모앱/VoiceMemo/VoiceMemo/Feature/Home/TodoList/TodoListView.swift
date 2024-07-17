//
//  TodoListView.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    var body: some View {
        WriteBtnView(
            content: {
                VStack {
                    if !todoListViewModel.todos.isEmpty {
                        CustomNavigationBar(
                            isDisplayLeftBtn: false,
                            rightBtnAction: {
                                todoListViewModel.navigationRightBtnTapped()
                            },
                            rightBtnType: todoListViewModel.navigationBarRightBtnMode
                        )
                    } else {
                        Spacer()
                            .frame(height: 30)
                    }
                    
                    TitleView()
                        .padding(.top, 20)
                    
                    if todoListViewModel.todos.isEmpty {
                        AnnoucementView()
                    } else {
                        TodoListContentView()
                    }
                }
        }, action: {
            pathModel.paths.append(.todoView)
        })
        .alert(
            "To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert) {
                Button(role: .destructive) {
                    todoListViewModel.removeBtnTapped()
                } label: {
                    Text("삭제")
                }
                
                Button(role: .cancel) { } label: {
                    Text("취소")
                }
            }
            .onChange(of: todoListViewModel.todos) { todos in
                homeViewModel.setTodoCount(todos.count)
            }
    }
}

// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
            } else {
                Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}


// MARK: - TodoList 안내 뷰
private struct AnnoucementView: View {
    
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            
            VStack(spacing: 5) {
                Text("\"매일 아침 5시 운동하자!\"")
                Text("\"내일 8시 수강 신청하자!\"")
                Text("\"1시 반 점심약속 리마인드 해보자!\"")
            }
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(.customGray2)
    }
}

// MARK: - TodoList 컨텐츠 뷰
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding([.leading, .top], 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}


// MARK: - Todo 셀 뷰
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                if !todoListViewModel.isEditTodoMode {
                    Button {
                        todoListViewModel.selectedBoxTapped(todo)
                    } label: {
                        todo.selected ? Image("selectedBox") : Image("unSelectedBox")
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundStyle(todo.selected ? .customIconGray : .customBlack)
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundStyle(.customIconGray)
                }
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button {
                        isRemoveSelected.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    } label: {
                        isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
        }
    }
}


// MARK: - Todo 작성 뷰
private struct WriteTodoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    pathModel.paths.append(.todoView)
                } label: {
                    Image("writeBtn")
                }
            }
        }
    }
}

#Preview {
    TodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
        .environmentObject(HomeViewModel())
}

# Album <사진첩> 📸
> <프로젝트 기간>

2023-02-03 ~ 2023-02-08

## 소개 📑
> PhotoKit 프레임워크를 이용하여 기기에 저장되어 있는 앨범과 사진을 불러오는 프로젝트입니다.
 
<br>

## 팀원 🤼‍♂️
|bonf| 
|:-------:|
| <img src="https://i.imgur.com/yGJljLR.jpg" width="350" height="350"/> |

<br>

## 요구 사항
Figma를 이용하여 요구사항을 구현해봤습니다.
[Figma-Album (로그인 시 코멘트 확인 가능)](https://www.figma.com/file/yQa13LB0ADMNKJgOnIupON/Album?node-id=0%3A1&t=CMDbdoQcFejV3WCx-1)

<br>

## 구현 화면 📱

|기능 구현|
|:-------:|
|<img src="https://i.imgur.com/Er17THI.gif" width="200" height="400"/> |

<br>

## 구현 내용 🧑‍💻

#### AlbumListView
- DiffableDataSource를 이용하여 TableView를 구성했습니다.
- 기본 사진 앱의 '나의 앨범'에 나타나는 앨범을 가져옵니다. 
- image는 가장 최근 사진 1장을 나타냅니다.
- 각 셀 항목을 클릭하면 해당 앨범의 상세로 진입해 사진 모아보기 화면으로 이동합니다.


#### ImagesView
- DiffableDataSource와 CompositionalLayout을 이용하여 CollectionView를 구성했습니다.
- 이미지가 없을 경우 EmptyView를 보여주도록 구현했습니다.
- 각 이미지를 클릭하면 해당 이미지의 상세 정보(파일명, 파일크기)를 AlertView로 present하도록 구현했습니다.

<br>

## 핵심 경험 💡
- [x] PhotoKit
- [x] CompositionalLayout
- [x] DiffableDataSource
- [x] MVC 패턴

<br>

## 트러블 슈팅 🧐
### 1. UserInterfaceState.xcuserstate 파일이 계속 생성되는 문제
- git에 commit하고 push를 해도 계속 변경사항이 생기는 문제가 발생했습니다.
- 위 파일은  workspace/project document layouts 상태를 저장하고 있는 파일로 알게 되었습니다. 
- 즉, 코드 실행과는 상관없는 파일인 것으로 인지하여 gitIgnore파일을 이용하여 해결했습니다.
- `Album/Album.xcodeproj/project.xcworkspace/xcuserdata/bonf.xcuserdatad/UserInterfaceState.xcuserstate`
코드를 gitIgnore 파일에 추가해 주었습니다.

<br>

### 2. Album내부에 사진이 없을 경우 cell이 나타나지 않은 문제
<img src="https://i.imgur.com/3WVq9CO.png" width="200" height="400"/> 

- 위 사진처럼 favorite앨범이 비어져 있는 경우 cell이 나타나지 않은 문제가 발생했습니다.
- View Hierarchy 확인 결과 guard let 으로 옵셔널 바인딩을 하는 과정에서 else 구문인 UITableViewCell()이 반환되어 customCell이 나타나지 않는 것으로 확인했습니다.
- if let으로 옵셔널 바인딩하여 예외 처리하며 해결하였습니다.

<br>

### 3. 앨범 상세 확인 후 돌아왔을 때 cell 배경화면이 바뀌는 문제
<img src="https://i.imgur.com/ozI4LyV.gif" width="200" height="400"/> 

- delegate 의 override 함수인 didSelectRowAt을 이용하여 터치 이벤트를 구현했는데, 다시 돌아왔을 때 배경화면이 gray로 변경되어있는 문제가 발생했습니다.
- didSelectRowAt에서 ImageView로 push한 뒤         `albumsTableView.deselectRow(at: indexPath, animated: true)`
코드를 추가하여 해결하였습니다.

---

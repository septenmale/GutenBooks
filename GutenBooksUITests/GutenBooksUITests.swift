//
//  GutenBooksUITests.swift
//  GutenBooksUITests
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import XCTest

final class GutenBooksUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func test_addFirstBookToFavorites_fromDetail_appearsInFavoritesTab() {
        let booksList = app.collectionViews["booksList"]
        XCTAssertTrue(booksList.waitForExistence(timeout: 10), "booksList should appear on screen")
        
        let firstCell = booksList.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "First book cell should appear")
        firstCell.tap()
        
        let detailFavoriteButton = app.buttons["bookDetailFavoriteButton"]
        XCTAssertTrue(detailFavoriteButton.waitForExistence(timeout: 10), "Favorite button on BookDetailView should appear")
        detailFavoriteButton.tap()
        
        let favoritesTabButton = app.tabBars.buttons["Favorites"]
        XCTAssertTrue(favoritesTabButton.waitForExistence(timeout: 5), "Favorites tab button should exist")
        favoritesTabButton.tap()
        
        let favoritesRoot = app.otherElements["favoritesTabRoot"]
        XCTAssertTrue(favoritesRoot.waitForExistence(timeout: 5), "favoritesTabRoot should exist")
        
        let favoritesList = app.collectionViews["favoritesList"]
        XCTAssertTrue(favoritesList.waitForExistence(timeout: 10), "favoritesList should appear after adding a favorite")
        
        XCTAssertTrue(favoritesList.cells.element(boundBy: 0).waitForExistence(timeout: 5),
                      "Favorites list should contain at least one cell")
    }
    
    func test_removeFromFavorites_showsEmptyState() {
        let booksList = app.collectionViews["booksList"]
        XCTAssertTrue(booksList.waitForExistence(timeout: 10))
        
        let firstBooksCell = booksList.cells.element(boundBy: 0)
        XCTAssertTrue(firstBooksCell.waitForExistence(timeout: 10))
        firstBooksCell.tap()
        
        let detailFavoriteButton = app.buttons["bookDetailFavoriteButton"]
        XCTAssertTrue(detailFavoriteButton.waitForExistence(timeout: 10))
        detailFavoriteButton.tap()
        
        let favoritesTabButton = app.tabBars.buttons["Favorites"]
        XCTAssertTrue(favoritesTabButton.waitForExistence(timeout: 5))
        favoritesTabButton.tap()
        
        let favoritesRoot = app.otherElements["favoritesTabRoot"]
        XCTAssertTrue(favoritesRoot.waitForExistence(timeout: 5))
        
        let favoritesList = app.collectionViews["favoritesList"]
        XCTAssertTrue(favoritesList.waitForExistence(timeout: 10), "favoritesList should exist after adding a favorite")
        
        let firstFavoritesCell = favoritesList.cells.element(boundBy: 0)
        XCTAssertTrue(firstFavoritesCell.waitForExistence(timeout: 10))
        firstFavoritesCell.tap()
        
        let removeButton = app.buttons["bookDetailFavoriteButton"]
        XCTAssertTrue(removeButton.waitForExistence(timeout: 10))
        removeButton.tap()
        
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        backButton.tap()
        
        let emptyState = app.otherElements["emptyState"]
        XCTAssertTrue(emptyState.waitForExistence(timeout: 10), "EmptyStateView should appear after removing the only favorite")
        
        XCTAssertFalse(favoritesList.exists, "favoritesList should disappear when favorites become empty")
    }
}
